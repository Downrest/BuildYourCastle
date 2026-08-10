local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Squash = require(ReplicatedStorage.SharedPackages.Squash)
local TypedEvent = require(ReplicatedStorage.SharedPackages.TypedEvent)

local CastleSharedService = {}

export type BatchedCastleReplication = {CastleReplication}
export type CastleReplication = {
    castleID: number;
    unlockedStructures: {string};
}

local sharedAssets = ReplicatedStorage.SharedAssets
local castleAssets = sharedAssets.Castle
local castleIslandModel = castleAssets.CastleIsland
local castleProgressions = castleAssets.Progression

CastleSharedService.STRUCTURE_NAMES = {
	Pathway1 = "Pathway1";
}
CastleSharedService.STRUCTURE_NAME_TO_ASSET = {
    [CastleSharedService.STRUCTURE_NAMES.Pathway1] = castleProgressions["1. Pathway (10)"];
}
CastleSharedService.ISLAND_ASSET = castleIslandModel

CastleSharedService.ClientReplicationReady =
    TypedEvent.newReliable("ClientReplicationReady"):: TypedEvent.ClientToServer<any>

CastleSharedService.ReplicationPacket =
    TypedEvent.newReliable("IslandReplicationPacket"):: TypedEvent.ServerToClient<(replicationBuffer: buffer) -> ()>

--[[
    THE REPLICATION FORMAT IS AS FOLLOWS:

    `castleID` denotes the castle type to place structures in (client renders castle type if not existing yet)
    `unlockedStructures` denotes the structures in that castle type to be rendered
]]
local castleReplicationSerde = Squash.record({
    castleID = Squash.T(Squash.i8());
    unlockedStructures = Squash.T(Squash.array(Squash.string()));
})
local batchCastleReplicationSerde = Squash.array(castleReplicationSerde);

function CastleSharedService.SerializeReplicationPacket(batchCastleReplication: BatchedCastleReplication): buffer
    local cursor = Squash.cursor()

    batchCastleReplicationSerde.ser(cursor, batchCastleReplication)

    return Squash.tobuffer(cursor)
end

function CastleSharedService.DeserializeReplicationPacket(batchCastleReplication: buffer): BatchedCastleReplication
    local cursor = Squash.frombuffer(batchCastleReplication)

    return batchCastleReplicationSerde.des(cursor)
end

return CastleSharedService
