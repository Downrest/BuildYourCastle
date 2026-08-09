local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local Lyra = require(ReplicatedStorage.SharedPackages.Lyra)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local t = require(ReplicatedStorage.SharedPackages.t)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local DataServerService = {}

export type PlayerData = {
    currency: {
        gold: number;
    }
}

DataServerService.DataChanged = Signal.new<<(player: Player, newData: PlayerData, oldData: PlayerData?) -> ()>>()

local playerStore = Lyra.createPlayerStore<<PlayerData>>({
    name = "PlayerData";
    template = {
        currency = {
            gold = 10_000;
        };
        castle = {
            popularity = 0;
            -- unlockedButtons = {
            --     [CastleServerService.STRUCTURE_NAMES.Pathway1] = false;
            -- };
        };
    };
    schema = t.strictInterface({
        currency = t.strictInterface({
            gold = t.number;
        });
        castle = t.strictInterface({
            popularity = t.number;
            -- unlockedButtons = t.strictInterface({
            --     [t.string] = t.boolean;
            -- })
        })
    });
    changedCallbacks = {
        function(userId, newData, oldData)
            local player = Players:GetPlayerByUserId(tonumber(userId):: number)
            if not player then
                return
            end

            DataServerService.DataChanged:Fire(player, newData, oldData)
        end;
    };
    
    -- TESTING...
    -- logCallback = function()
    --     if RunService:IsStudio() then
    --         -- Show all logs in Studio
    --         return function(message)
    --             print(`[Lyra][{message.level}] {message.message}`)
    --             if message.context then
    --                 print("Context:", message.context)
    --             end
    --         end
    --     else
    --         -- Only show errors in production
    --         return function(message)
    --             if message.level == "error" or message.level == "fatal" then
    --                 warn(`[Lyra] {message.message}`)
    --             end
    --         end
    --     end
    -- end;
})

function DataServerService.Init()
    -- client handshake, "im ready for data replication!"
    DataSharedService.ClientDataReady.server.OnServerEvent:Connect(function(player)
        DataServerService.DataChanged:Fire(player, playerStore:getAsync(player))
    end)

    Players.PlayerAdded:Connect(function(player)
        playerStore:loadAsync(player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        playerStore:unloadAsync(player)
    end)

    game:BindToClose(function()
        playerStore:closeAsync()
    end)
end

function DataServerService.GetPlayerData(player: Player): PlayerData
    return playerStore:getAsync(player)
end

function DataServerService.SetGold(player: Player, goldAmount: number)
    playerStore:updateAsync(player, function(data)
        data.currency.gold = goldAmount
        return true
    end)
end

return DataServerService
