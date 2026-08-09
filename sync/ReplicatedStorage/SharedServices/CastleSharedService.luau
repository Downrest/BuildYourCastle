local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Squash = require(ReplicatedStorage.SharedPackages.Squash)
local TypedEvent = require(ReplicatedStorage.SharedPackages.TypedEvent)

local CastleSharedService = {}

export type CastleReplication = {string}

CastleSharedService.STRUCTURE_NAMES = {
	Pathway1 = "Pathway1";
}

CastleSharedService.ClientReplicationReady =
    TypedEvent.newReliable("ClientReplicationReady"):: TypedEvent.ClientToServer<any>

CastleSharedService.ReplicationPacket =
    TypedEvent.newReliable("ReplicationPacket"):: TypedEvent.ServerToClient<(replicatedBuffer: buffer) -> ()>

function CastleSharedService.SerializeCastleReplication(castleReplication: CastleReplication): buffer
    local cursor = Squash.cursor()

    for _, unlockedStructureName in castleReplication do
        Squash.string().ser(cursor, unlockedStructureName)
    end
    Squash.vlq().ser(cursor, #castleReplication)

    return Squash.tobuffer(cursor)
end

function CastleSharedService.DeserializeCastleReplication(replicationBuffer: buffer): CastleReplication
    local cursor = Squash.frombuffer(replicationBuffer)
    local castleReplication = {}

    local unlockedStructureAmount = Squash.vlq().des(cursor)
    for index = unlockedStructureAmount, 1, -1 do
        table.insert(
            castleReplication, 
            Squash.string().des(cursor)
        )
    end

    return castleReplication
end

return CastleSharedService
