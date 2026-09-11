local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ReplicationController = {}

local MAX_REPLICATION_PER_STEP = 20
local INITIAL_STEP_RATE = 1
local RESUMING_STEP_RATE = 1/40

local stepRate = INITIAL_STEP_RATE
local stepAccumulator = 0

type ReplicationQueue = {CastleSharedService.CastleReplication}

local generalReplicationQueue = {
    head = 0;
    size = 0;
    queue = {};
}:: ReplicationQueue
local playerReplicationQueue = {}:: {[Player]: ReplicationQueue}

local function popReplicationFromQueue(replicationQueue: ReplicationQueue)
    local poppedValues = {}
    
    -- custom head index, avoid array shifting from table.remove()
    for iteration = 1, MAX_REPLICATION_PER_STEP do
        local queuedReplication = replicationQueue[1]
        if not queuedReplication then
            break
        end

        table.insert(poppedValues, queuedReplication)
        table.remove(replicationQueue, 1)
    end

    return poppedValues
end

function ReplicationController.Init()
    do
        CastleSharedService.InitRender(true)
    end

    RunService.Heartbeat:Connect(function(deltaTime)
        stepAccumulator += deltaTime
        if stepAccumulator < stepRate then
            return
        else
            stepAccumulator %= stepRate

            --[[
                this is to let the engine initially load
                batches every initial queued castle replication (on init)
            ]]
            if stepRate == INITIAL_STEP_RATE then
                stepRate = RESUMING_STEP_RATE
            end
        end

        if #generalReplicationQueue > 0 then
            local batchedReplicationData = popReplicationFromQueue(generalReplicationQueue)

            CastleSharedService.ReplicationPacket.server:FireAllClients(
                CastleSharedService.SerializeReplicationPacket(batchedReplicationData)
            )
        end

        for player, replicationQueue in playerReplicationQueue do
            if #replicationQueue == 0 then
                continue
            end

            local batchedReplicationData = popReplicationFromQueue(replicationQueue)

            CastleSharedService.ReplicationPacket.server:FireClient(
                player,
                CastleSharedService.SerializeReplicationPacket(batchedReplicationData)
            )
        end
    end)
end

function ReplicationController.CastleCacheToReplication(
    castleID: number,
    castleStructureData: CastleServerService.StructureData,
    isDestructive: boolean? -- if enabled, sends a completely new + overriding replication state
)
    local unlockedStructures = {}; do
        for structureName, booleanData in castleStructureData do
            local isPurchaseable, isUnlocked = booleanData[1], booleanData[2]
            if not isPurchaseable then
                continue
            end

           unlockedStructures[structureName] = isUnlocked
        end
    end

    return {
        castleID = castleID;
        isDestructive = (not not isDestructive);
        unlockedStructures = unlockedStructures;
    }
end

function ReplicationController.RegisterPlayer(player: Player)
    playerReplicationQueue[player] = {}
end

function ReplicationController.ReplicateToAll(castleReplication: CastleSharedService.CastleReplication)
    table.insert(generalReplicationQueue, castleReplication)
    CastleSharedService.RenderCastleReplication(castleReplication)
end

function ReplicationController.ReplicatePlayer(player: Player, castleReplication: CastleSharedService.CastleReplication)
    table.insert(playerReplicationQueue[player], castleReplication)
    CastleSharedService.RenderCastleReplication(castleReplication)
end

return ReplicationController
