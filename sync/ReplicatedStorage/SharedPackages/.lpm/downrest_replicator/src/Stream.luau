local Replica = require("./Replica")
local Types = require("./Shared/Types")
local Utils = require("./Shared/Utils")

local Stream = {}

export type Stream<data = any> = {
    Replica: (self: Stream<data>, replicaKey: Types.ReplicaKey) -> Replica.Replica<data>;
}
type PrivateStream<data = any> = {
    _replicaList: {[Types.ReplicaKey]: Replica.Replica<data>};
    _streamFolder: Folder;
}

local streamList = {}:: {[Types.StreamKey]: any}

function Stream.stream<data>(streamKey: Types.StreamKey, initData: data): Stream<data>
    Utils.AssertStreamKey(streamKey)

    local self = streamList[streamKey]
    if not self then
        self = {}:: (Stream<data> & PrivateStream<data>)

        do
            self._replicaList = {}
            self._streamFolder = Utils.GetStreamFolder(streamKey); do
                Utils.GetStreamHandshakeFunction(streamKey, self._streamFolder)
                Utils.GetStreamUpdateEvent(streamKey, self._streamFolder)
            end

            function self.Replica(self: Stream<data>, replicaKey: Types.ReplicaKey): Replica.Replica<data>
                self = (self:: Stream<data> & PrivateStream<data>)

                local replica = self._replicaList[replicaKey]

                if not replica then
                    replica = Replica.replica(
                        streamKey, 
                        replicaKey,
                        initData
                    )
                    self._replicaList = replica
                end

                return replica
            end
        end

        streamList[streamKey] = self
    end

    return self
end

return Stream