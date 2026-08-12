local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ReplicationController = {}

local MAX_REPLICATION_PER_STEP = 20
local STEP_RATE = 1/40

local stepAccumulator = 0
local clientReplicationQueue = {}:: {CastleSharedService.CastleReplication}

function ReplicationController.Init()
    CastleSharedService.InitRender(true)

    RunService.Heartbeat:Connect(function(deltaTime)
        stepAccumulator += deltaTime
        if stepAccumulator < STEP_RATE then
            return
        else
            stepAccumulator %= STEP_RATE
        end

        if #clientReplicationQueue == 0 then
            return
        end

        local batchedReplicationData = {}:: {CastleSharedService.CastleReplication}
        for index = 1, MAX_REPLICATION_PER_STEP do
            local queuedReplication = clientReplicationQueue[index]
            if not queuedReplication then
                break
            end

            table.insert(batchedReplicationData, queuedReplication)
            table.remove(clientReplicationQueue, index)
        end

        warn("REPLICATINGGG..... ", batchedReplicationData)
        CastleSharedService.ReplicationPacket.server:FireAllClients(
            CastleSharedService.SerializeReplicationPacket(batchedReplicationData)
        )
    end)
end

function ReplicationController.RenderAndReplicateCastle(castleReplication: CastleSharedService.CastleReplication)
    CastleSharedService.RenderCastleReplication(castleReplication)

    table.insert(clientReplicationQueue, castleReplication)
end

return ReplicationController
