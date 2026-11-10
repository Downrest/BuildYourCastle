local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleRenderSharedService = require(ReplicatedStorage.SharedServices.CastleServices.CastleRenderSharedService)
local CastleReplicationSharedService = require(ReplicatedStorage.SharedServices.CastleServices.CastleReplicationSharedService)
local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local TransactionServerService = require(ServerScriptService.ServerServices.TransactionServerService)
local ReplicationController = require(script.ReplicationController)

local CastleServerController = {}

function CastleServerController.Init()
    do
        ReplicationController.Init()
        CastleServerService.Init()
    end

    CastleReplicationSharedService.RequestTotalReplicationPackets.server.OnServerInvoke = function(player: Player)
        local batchedReplicationData = {}:: {CastleReplicationSharedService.CastleReplication}

        for _, castleCache in CastleServerService.GetCastleCacheList() do
            local castleID = castleCache.castleID
            local castleStructureData = castleCache.castleData 
                and castleCache.castleData.structureData
                or {}

            table.insert(
                batchedReplicationData,
                ReplicationController.CastleCacheToReplication(
                    castleID,
                    castleStructureData
                )
            )
        end

        return CastleReplicationSharedService.SerializeReplicationPacket(
            batchedReplicationData
        )
    end

    -- replicate initialized player cache to rest of players
    CastleServerService.PlayerCastleInitialized:Connect(function(
        player,
        initCastleID,
        initStructureData
    )
        ReplicationController.RegisterPlayer(player)

        ReplicationController.ReplicateToAll(
            ReplicationController.CastleCacheToReplication(
                initCastleID,
                initStructureData
            )
        )
    end)

    -- replicates delta structure data
    CastleServerService.PlayerCastleChanged:Connect(function(
        player,
        castleID,
        newStructureData,
        previousStructureData
    )
        local deltaStructureData = {}; do
            for structureID, booleanData in newStructureData do
                local previousBooleanData = previousStructureData[structureID]
                if 
                    previousBooleanData[1] == booleanData[1]
                    and previousBooleanData[2] == booleanData[2]
                then
                    continue
                end
    
                deltaStructureData[structureID] = booleanData
            end
        end

        ReplicationController.ReplicateToAll(
            ReplicationController.CastleCacheToReplication(
                castleID,
                deltaStructureData
            )
        )
    end)

    -- rerenders released player castle into a blank
    CastleServerService.PlayerCastleReleased:Connect(function(
        player
    )
        for _, castleCache in CastleServerService.GetCastleCacheList() do
            local castleID = castleCache.castleID
            local castleStructureData = castleCache.castleData 
                and castleCache.castleData.structureData
                or {}

            ReplicationController.ReplicatePlayer(
                player, 
                ReplicationController.CastleCacheToReplication(
                    castleID,
                    castleStructureData
                )
            )
        end
    end)

    -- handle structure purchases
    CastleRenderSharedService.ClientTouchedStructurePurchase.server.OnServerEvent:Connect(function(
        player,
        structureID
    )
        local purchaseSuccess = TransactionServerService.PurchaseCastleStructure(
            player,
            structureID
        )

        -- return purchase status
        CastleRenderSharedService.ServerPurchaseStatus.server:FireClient(player, purchaseSuccess)
    end)
end

return CastleServerController