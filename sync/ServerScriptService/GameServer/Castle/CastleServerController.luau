local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local TableUtil = require(ReplicatedStorage.SharedUtils.TableUtil)
local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)
local PurchaseServerService = require(ServerScriptService.ServerServices.PurchaseServerService)
local ReplicationController = require(script.ReplicationController)

local CastleServerController = {}

function CastleServerController.Init()
    do
        ReplicationController.Init()
        CastleServerService.Init()
    end

    -- replicate all existing cache to initialized player
    CastleSharedService.ClientReplicationReady.server.OnServerEvent:Connect(function(
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
    CastleSharedService.ClientTouchedStructurePurchase.server.OnServerEvent:Connect(function(
        player,
        structureID
    )
        local purchaseSuccess = PurchaseServerService.PurchaseCastleStructure(
            player,
            structureID
        )

        -- return purchase status
        CastleSharedService.ServerPurchaseStatus.server:FireClient(player, purchaseSuccess)
    end)
end

return CastleServerController