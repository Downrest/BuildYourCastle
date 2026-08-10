local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

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
            for structureName, isPurchased in castleCache.castleData.unlockedButtons do
                if not isPurchased then
                    continue
                end
    
                table.insert(castleReplication.unlockedStructures, structureName)
            end
        end
    end

    return castleReplication
end

local function sendCastleReplication(player: Player, batchCastleReplication: CastleSharedService.BatchedCastleReplication)
    CastleSharedService.ReplicationPacket.server:FireClient(
        player,
        CastleSharedService.SerializeReplicationPacket(batchCastleReplication)
    )
end

local function replicateCastlesToNewPlayer(player: Player)
    DataServerService.OnPlayerDataLoaded(player, function()
        local batchedCastles = {}

        for _, castleCache in CastleServerService.GetCastleCaches() do
            table.insert(batchedCastles, castleCacheToReplication(castleCache))
        end

        sendCastleReplication(player, batchedCastles)
    end)
end

local function addPlayerCastle(player: Player)
    DataServerService.OnPlayerDataLoaded(player, function()
        CastleServerService.AddPlayerCastle(player)
    end)
end

function CastleServerController.Init()
    CastleServerService.Init()

    do
        for _, player in Players:GetPlayers() do
            addPlayerCastle(player)
        end
        Players.PlayerAdded:Connect(function(player)
            addPlayerCastle(player)
        end)
    end

    CastleSharedService.ClientReplicationReady.server.OnServerEvent:Connect(function(player)
        replicateCastlesToNewPlayer(player)
    end)
end

return CastleServerController