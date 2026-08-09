local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)

local CastleServerController = {}

local function castleDataToReplication(castleData: CastleServerService.CastleData): CastleSharedService.CastleReplication
    local castleReplication = {}; do
        for structureName, isPurchased in castleData.unlockedButtons do
            if not isPurchased then
                continue
            end

            table.insert(castleReplication, structureName)
        end
    end

    return castleReplication
end

function CastleServerController.Init()
    CastleServerService.Init()

    do
        for _, player in Players:GetPlayers() do
            CastleServerService.AddPlayerCastle(player)
        end
        Players.PlayerAdded:Connect(function(player)
            CastleServerService.AddPlayerCastle(player)
        end)
    end

    CastleSharedService.ClientReplicationReady.server.OnServerEvent:Connect(function(player)
        local castleData = CastleServerService.GetPlayerCastleData(player)
        local castleReplication = castleDataToReplication(castleData)
        local replicationBuffer = CastleSharedService.SerializeCastleReplication(castleReplication)

        CastleSharedService.ReplicationPacket.server:FireAllClients(replicationBuffer)
    end)
end

return CastleServerController