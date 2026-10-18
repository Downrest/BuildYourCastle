local Types = require("./Types")
local Config = require("./Config")
local t = require("../../packages/roblox/t")

local Utils = {}

local STREAM_PARENT = script.Parent
local STREAM_KEY_CHECKER = t.string
local REPLICA_KEY_CHECKER = t.optional(t.instanceIsA("Player"))

local streamFolderCache = {}:: {[Types.StreamKey]: Folder}
local streamHandshakeFunctionCache = {}:: {[Types.StreamKey]: RemoteFunction}
local streamUpdateEventCache = {}:: {[Types.StreamKey]: RemoteEvent}

function Utils.DeepCopy<source>(source: source): source
    source = (source:: any)
    local copy = {}:: any

    for key, value in source do
        if typeof(value) == "table" then
            copy[key] = Utils.DeepCopy(value)
        else
            copy[key] = value
        end 
    end

    return copy
end

function Utils.ReplaceCopy(source: any, toCopy: any)
    for key, value in toCopy do
        if typeof(value) == "table" then
            local sourceLayer = source[key]; do
                if not sourceLayer then
                    source[key] = {}
                    sourceLayer = source[key]
                end
            end
            local toCopyLayer = toCopy[key]

            Utils.ReplaceCopy(sourceLayer, toCopyLayer)
        else
            source[key] = toCopy[key]
        end
    end
end

function Utils.GetStreamFolder(streamKey: Types.StreamKey): Folder
    local streamFolder = streamFolderCache[streamKey]

    if not streamFolder then
        local folderName = streamKey..Config.STREAM_SUFFIX

        if Config.IS_SERVER then
            streamFolder = Instance.new("Folder")
            streamFolder.Parent = STREAM_PARENT
            streamFolder.Name = folderName
        else
            streamFolder = STREAM_PARENT:WaitForChild(folderName):: Folder
            assert(streamFolder, `Client failed to sync with {streamKey}, are you sure both client/server acknowledge the stream?`)
        end

        streamFolderCache[streamKey] = streamFolder
    end

    return streamFolder
end

function Utils.GetStreamHandshakeFunction(streamKey: Types.StreamKey, streamFolder: Folder?): RemoteFunction
    local streamHandshakeFunction = streamHandshakeFunctionCache[streamKey]

    if not streamHandshakeFunction then
        streamFolder = streamFolder or Utils.GetStreamFolder(streamKey)
        local handshakeName = streamKey..Config.HANDSHAKE_FUNCTION_SUFFIX

        if Config.IS_SERVER then
            streamHandshakeFunction = Instance.new("RemoteFunction")
            streamHandshakeFunction.Parent = streamFolder
            streamHandshakeFunction.Name = handshakeName
        else
            streamHandshakeFunction = streamFolder:WaitForChild(handshakeName):: RemoteFunction
        end

        streamHandshakeFunctionCache[streamKey] = streamHandshakeFunction
    end

    return streamHandshakeFunction
end

function Utils.GetStreamUpdateEvent(streamKey: Types.StreamKey, streamFolder: Folder?): RemoteEvent
    local streamUpdateEvent = streamUpdateEventCache[streamKey]

    if not streamUpdateEvent then
        streamFolder = streamFolder or Utils.GetStreamFolder(streamKey)
        local eventName = streamKey..Config.UPDATE_EVENT_SUFFIX

        if Config.IS_SERVER then
            streamUpdateEvent = Instance.new("RemoteEvent")
            streamUpdateEvent.Parent = streamFolder
            streamUpdateEvent.Name = eventName
        else
            streamUpdateEvent = streamFolder:WaitForChild(eventName):: RemoteEvent
        end

        streamUpdateEventCache[streamKey] = streamUpdateEvent
    end

    return streamUpdateEvent
end

function Utils.AssertStreamKey(streamKey: Types.StreamKey)
    assert(STREAM_KEY_CHECKER(streamKey), `Invalid stream key of type {typeof(streamKey)}`)
end

function Utils.AssertReplicaKey(replicaKey: Types.ReplicaKey)
    assert(REPLICA_KEY_CHECKER(replicaKey), `Invalid replica key of type {typeof(replicaKey)} {typeof(replicaKey) == "Instance" and replicaKey.ClassName}`)
end

function Utils.AssertRepeatedStream(streamKey: Types.StreamKey)
    assert(not streamFolderCache[streamKey], `Stream {streamKey} already exists`)
end

return Utils