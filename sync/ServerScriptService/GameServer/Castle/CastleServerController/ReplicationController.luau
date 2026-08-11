local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ReplicationController = {}

local MAX_REPLICATION_PER_STEP = 20
local STEP_RATE = 1/40

local stepAccumulator = 0
local replicationQueue = {}:: {CastleSharedService.CastleReplication}

function ReplicationController.InitStep()
    RunService.Heartbeat:Connect(function(deltaTime)
        stepAccumulator += deltaTime
        if stepAccumulator < STEP_RATE then
            return
        else
            stepAccumulator %= STEP_RATE
        end

        if #replicationQueue == 0 then
            return
        end

        local batchedReplicationData = {}:: {CastleSharedService.CastleReplication}
        for index = 1, MAX_REPLICATION_PER_STEP do
            local queuedReplication = replicationQueue[index]
            if not queuedReplication then
                break
            end

            table.insert(batchedReplicationData, queuedReplication)
            table.remove(replicationQueue, index)
        end

        CastleSharedService.ReplicationPacket.server:FireAllClients(
            CastleSharedService.SerializeReplicationPacket(batchedReplicationData)
        )
    end)
end

function ReplicationController.PushReplicationToQueue(castleReplication: CastleSharedService.CastleReplication)
    table.insert(replicationQueue, castleReplication)
end

return ReplicationController
