local Config = require("./Shared/Config")
local Types = require("./Shared/Types")
local Utils = require("./Shared/Utils")
local Signal = require("../packages/roblox/Signal")
local DeltaCompress = require("../packages/roblox/DeltaCompress")

local Replica = {}

type function SchemaToReplica(table: type)
    if table.tag ~= "table" then
        if table.tag == "any" then
            table = types.newtable()
        else
            print(`Attempted to insert a replica type that is neither a valid table or generic "any"`)
        end
    end

    local replica = types.newtable()

    for key, value in table:properties() do
        if not value.read then
            continue
        end
        
        if value.read.tag == "table" then
            replica:setproperty(key, SchemaToReplica(value.read))
        else
            replica:setproperty(key, Source(value.read))
        end
	end

	return replica
end
export type Replica<data> = SchemaToReplica<data>
type PrivateReplica<data> = {
    _streamFolder: Folder;
    _handshakeFunction: RemoteFunction;
    _updateEvent: RemoteEvent;

    _replicaId: string;
    _globalChangedSignal: Signal.Signal;

    _previousReferenceData: ReferenceLayer;
    _currentReferenceData: ReferenceLayer;
    _reflectionData: ReflectionLayer;
}

type Source<type = any> = {
    Set: (self: Source<type>, setValue: type) -> ();
    Get: (self: Source<type>) -> type;

    Observed: (observedCallback: (current: type, previous: type) -> ()) -> Signal.Connection;
    Changed: (changedCallback: (new: type, previous: type) -> ()) -> Signal.Connection;
}
type PrivateSource<type = any> = {
    _isSource: boolean;
    _valueTypeName: string;
    _sourceChangedSignal: Signal.Signal<(new: type, old: type?) -> ()>; 
}

type ReplicaLayer = {[any]: Source | ReplicaLayer}
type ReflectionLayer = {[any]: any | ReflectionLayer}
type ReferenceLayer = {[any]: any | ReferenceLayer}

local function reflectNew(reflectionLayer: ReflectionLayer, new: {[any]: any})
    for key, value in new do
        if typeof(value) == "table" then
            reflectNew(reflectionLayer, value)
        else
            new[key] = value
        end
    end
end

local function fillReplica(
    replicaLayer: ReplicaLayer,
    reflectionLayer: ReflectionLayer,
    previousReferenceLayer: ReferenceLayer,
    referenceLayer: ReferenceLayer,

    globalChangedSignal: Signal.Signal
)
    for referenceKey, referenceValue in referenceLayer do
        if typeof(referenceValue) == "table" then
            local replicaValue = {}; do
                replicaLayer[referenceKey] = replicaValue
            end
            local reflectionValue = {}; do
                reflectionLayer[referenceKey] = reflectionValue
            end
            local previousReferenceValue = {}; do
                previousReferenceLayer[referenceKey] = previousReferenceValue
            end
            
            fillReplica(
                replicaValue,
                reflectionValue,
                previousReferenceValue,
                referenceValue,

                globalChangedSignal
            ) 
        else
            local source = {
                _isSource = true;
                _valueTypeName = typeof(referenceValue);
                _previousValue = nil;
                _sourceChangedSignal = Signal.new<<(new: any, old: any?) -> ()>>();
            }:: Source & PrivateSource

            -- setters/getters
            do
                function source.Set<type>(self: Source<type> & PrivateSource<type>, setValue: type)
                    local setValueType = typeof(setValue); do
                        -- in the future, i could support defined schemas
                        assert(setValueType == self._valueTypeName, `Attempted to set {referenceKey} of type {self._valueTypeName} with type {setValueType}`)
                    end

                    if setValue == referenceLayer[referenceKey] then
                        return
                    end
    
                    previousReferenceLayer[referenceKey] = referenceLayer[referenceKey]
                    referenceLayer[referenceKey] = setValue
    
                    source._sourceChangedSignal:Fire(referenceLayer[referenceKey], previousReferenceLayer[referenceKey])
                    globalChangedSignal:Fire()
                end
                function source.Get<type>(self: Source<type>): type
                    return referenceLayer[referenceKey]
                end
            end

            -- signals
            do
                function source.Observed<type>(observedCallback: (current: type, previous: type?) -> ())
                    local changedSignal = source.Changed(observedCallback)
                    observedCallback(source:Get())
    
                    return changedSignal
                end
                function source.Changed<type>(changedCallback: (new: type, previous: type?) -> ())
                    return source._sourceChangedSignal:Connect(changedCallback):: Signal.Connection<(...any) -> ()>
                end
            end

            replicaLayer[referenceKey] = source
        end
    end

    setmetatable(
        reflectionLayer,
        {
            __newindex = function(table, key, value)
                local source = replicaLayer[key]:: Source & PrivateSource; do
                    assert(source, `{key} is not a valid source`)
                    if not source._isSource then
                        return
                    end
                end

                source:Set(value)
            end
        }
    )
end

function Replica.replica<data>(streamKey: Types.StreamKey, replicaKey: Types.ReplicaKey, initData: data): Replica<data>
    Utils.AssertStreamKey(streamKey)
    Utils.AssertReplicaKey(replicaKey)

    -- will have same public typeshape of data, except the values are sources
    local self = {}:: Replica<data> & PrivateReplica<data>

    self._streamFolder = Utils.GetStreamFolder(streamKey)
    self._handshakeFunction = Utils.GetStreamHandshakeFunction(streamKey, self._streamFolder)
    self._updateEvent = Utils.GetStreamUpdateEvent(streamKey, self._streamFolder)

    if replicaKey then
        self._replicaId = Config.GLOBAL_REPLICA_ID
    else
        self._replicaId = tostring(replicaKey)
    end
    self._globalChangedSignal = Signal.new()

    do
        self._previousReferenceData = {}
        self._currentReferenceData = Utils.DeepCopy(initData)

        self._reflectionData = {}

        fillReplica(
            self,
            self._reflectionData,
            self._previousReferenceData,
            self._currentReferenceData,

            self._globalChangedSignal
        )
    end

    -- data change -> replication
    do
        if Config.IS_SERVER then
            self._globalChangedSignal:Connect(function()
                local diff, old = DeltaCompress.diffMutable(self._previousReferenceData, self._currentReferenceData); do
                    assert(diff, `DeltaCompress failed to load diff buffer`)
                end
    
				self._previousReferenceData = old
                if replicaKey then
                    self._updateEvent:FireClient(replicaKey, self._replicaId, diff)
                else
                    self._updateEvent:FireAllClients(self._replicaId, diff)
                end
            end)
            
            self._handshakeFunction.OnServerInvoke = function(invokedPlayer: Player, replicaId: string): buffer?
                if 
                    (replicaKey and invokedPlayer ~= replicaKey)
                    or replicaId ~= self._replicaId 
                then
                    return nil
                end

                return DeltaCompress.diffMutable(nil, self._currentReferenceData)
            end
        else
            self._updateEvent.OnClientEvent:Connect(function(replicaId: string, diff: buffer)
                if replicaId ~= self._replicaId then
                    return
                end

                DeltaCompress.applyMutable(self._reflectionData, diff)
            end)

            local diff: buffer? = self._handshakeFunction:InvokeServer(self._replicaId); do
                if diff then
                    --[[
                        applyMutable, depending on old from diffMutable(old, ...), can overwrite _reflectionData itself (we dont want this)
                        hence why we manually copy the data initially just to be safe
                    ]]
                    reflectNew(
                        self._reflectionData,
                        DeltaCompress.applyImmutable(self._reflectionData, diff)
                    )
                end
            end
        end
    end

    return self
end

return Replica