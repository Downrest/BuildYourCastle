local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local TableUtil = require(ReplicatedStorage.SharedUtils.TableUtil)
local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)
local ReplicationController = require(script.ReplicationController)
local ClientPurchaseController = require(script.ClientPurchaseController)

local CastleServerController = {}

local function castleCacheToReplication(castleCache: CastleServerService.CastleCache): CastleSharedService.CastleReplication
    assert(
        castleCache,
        "Attempted to convert nil castle cache into castle replication."
    )

    local castleReplication = {
        castleID = castleCache.castleID;
        unlockedStructures = {};
    }; do
        if castleCache["castleData"] then
            for structureName, booleanData in castleCache.castleData.structureData do
                local isPurchaseable, isUnlocked = booleanData[1], booleanData[2]
                if not isPurchaseable then
                    continue
                end

                castleReplication.unlockedStructures[structureName] = isUnlocked
            end
        end
    end

    return castleReplication
end

local function replicateCastlesToNewPlayer(player: Player)
    DataServerService.OnPlayerDataInitialized(player, function()
        warn(`OH NEW PLAYER.. TRY TO RENDER..`, CastleServerService.GetPlayerCastleCacheList())
        for _, castleCache in CastleServerService.GetPlayerCastleCacheList() do
            local castleReplication = castleCacheToReplication(castleCache)

            ReplicationController.RenderAndReplicateCastle(castleReplication)
        end
    end)
end

local function addPlayerCastle(player: Player)
    DataServerService.OnPlayerDataInitialized(player, function()
        local castleCache = CastleServerService.AddPlayerCastleCache(player)
        local castleReplication = castleCacheToReplication(castleCache)

        ReplicationController.RenderAndReplicateCastle(castleReplication)
    end)
end

local function trackCastleCacheDelta(player: Player)
    local previousCastleCache = TableUtil.DeepCopy(
        CastleServerService.GetPlayerCastleCache(player)
    )
    assert(previousCastleCache and previousCastleCache.castleData, "Attempted to track structure purchase with nil castle cache!")

    return {
        ReplicateCastleCacheDelta = function()
            local deltaCastleCache = TableUtil.DeepCopy(
                CastleServerService.GetPlayerCastleCache(player)
            ); do
                assert(deltaCastleCache and deltaCastleCache.castleData, "Attempted to replicate castle cache delta with nil castle cache!")

                -- remove the previous structures, leaving the new purchased structures
                for previousStructureID, previousBooleanData in previousCastleCache.castleData.structureData do
                    local deltaStructureBooleanData = deltaCastleCache.castleData.structureData[previousStructureID]

                    -- include it in delta cache because of state change
                    if 
                        previousBooleanData[1] ~= deltaStructureBooleanData[1] -- isPurchaseaable
                        or previousBooleanData[2] ~= deltaStructureBooleanData[2] -- isUnlocked
                    then
                        continue
                    end

                    deltaCastleCache.castleData.structureData[previousStructureID] = nil
                end
            end
            
            local deltaCastleReplication = castleCacheToReplication(deltaCastleCache)
            
            ReplicationController.RenderAndReplicateCastle(deltaCastleReplication)
        end
    }
end

function CastleServerController.Init()
    ReplicationController.Init()
    CastleServerService.Init()

    do
        for _, player in Players:GetPlayers() do
            addPlayerCastle(player)
        end
        Players.PlayerAdded:Connect(function(player)
            addPlayerCastle(player)
        end)
    end

    CastleSharedService.ClientReplicationReady.server.OnServerEvent:Connect(function(
        player
    )
        replicateCastlesToNewPlayer(player)
    end)

    CastleSharedService.ClientTouchedStructurePurchase.server.OnServerEvent:Connect(function(
        player,
        structureID
    )
        if CastleServerService.IsPlayerStructurePurchased(player, structureID) then
            return
        end

		local structureDelta = trackCastleCacheDelta(player)
        local purchaseSuccess = ClientPurchaseController.AttemptPurchase(player, structureID)

        if purchaseSuccess then
            structureDelta.ReplicateCastleCacheDelta()
        end
        CastleSharedService.ServerPurchaseStatus.server:FireClient(player, purchaseSuccess)
    end)
end

return CastleServerController