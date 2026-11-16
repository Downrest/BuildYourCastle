local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Squash = require(ReplicatedStorage.SharedPackages.Squash)
local TypedRemote = require(ReplicatedStorage.SharedPackages.TypedRemote)

local CastleReplicationSharedService = {}

export type BatchedCastleReplication = {CastleReplication}
export type CastleReplication = {
    castleID: number;
    isDestructive: boolean;
    --[[
        {[structureName -> string]: isUnlocked -> boolean}
    ]]
    unlockedStructures: {[string]: boolean};
}

CastleReplicationSharedService.RequestTotalReplicationPackets =
    TypedRemote.newFunction("RequestTotalReplication"):: TypedRemote.FromServerFunction<() -> buffer>
CastleReplicationSharedService.ReplicationPacket =
    TypedRemote.newReliableEvent("ReplicationPacket"):: TypedRemote.ToClientEvent<(replicationBuffer: buffer) -> ()>

local CASTLE_REPLICATION_SERDE = Squash.record({
    castleID = Squash.T(Squash.i8());
    isDestructive = Squash.T(Squash.literal(true, false));
    unlockedStructures = Squash.T(
        -- [structureName -> string]: isUnlocked -> boolean
        Squash.map<<string, boolean>>(
            Squash.string(),
            Squash.literal(true, false)
        )
    );
})
local BATCH_CASTLE_REPLICATION_SERDE = Squash.array(CASTLE_REPLICATION_SERDE);

function CastleReplicationSharedService.SerializeReplicationPacket(batchCastleReplication: BatchedCastleReplication): buffer
    local cursor = Squash.cursor()

    BATCH_CASTLE_REPLICATION_SERDE.ser(cursor, batchCastleReplication)

    return Squash.tobuffer(cursor)
end

function CastleReplicationSharedService.DeserializeReplicationPacket(replicationBuffer: buffer): BatchedCastleReplication
    local cursor = Squash.frombuffer(replicationBuffer)

    return BATCH_CASTLE_REPLICATION_SERDE.des(cursor)
end

return CastleReplicationSharedService