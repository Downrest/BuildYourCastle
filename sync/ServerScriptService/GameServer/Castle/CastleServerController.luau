local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)
local ReplicationController = require(script.ReplicationController)

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
            for structureName, booleanData in castleCache.castleData.unlockedButtons do
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

    warn("????")
    CastleSharedService.ClientReplicationReady.server.OnServerEvent:Connect(function(player)
        warn(`CLIENT IS READY....`)
        replicateCastlesToNewPlayer(player)
    end)
end

return CastleServerController