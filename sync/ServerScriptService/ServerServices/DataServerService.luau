local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lyra = require(ReplicatedStorage.SharedPackages.Lyra)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local t = require(ReplicatedStorage.SharedPackages.t)
local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local DataServerService = {}

export type CastleData = {
    popularity: number;
    unlockedButtons: {
        [string]: boolean;
    }
}
export type PlayerData = {
    currency: {
        gold: number;
    };
    castle: CastleData;
}

DataServerService.DataServiceInitialized = Signal.new()
DataServerService.PlayerDataChanged = Signal.new<<(player: Player, newData: PlayerData, oldData: PlayerData?) -> ()>>()
DataServerService.PlayerDataLoaded = Signal.new<<(player: Player) -> ()>>()
DataServerService.PlayerDataReleased = Signal.new<<(player: Player) -> ()>>()

DataServerService.PlayersLoaded = {}:: {Player}

local playerStore = Lyra.createPlayerStore<<PlayerData>>({
    name = "PlayerData";
    template = {
        currency = {
            gold = 10_000;
        };
        castle = {
            popularity = 0;
            unlockedButtons = {
                [CastleSharedService.STRUCTURE_NAMES.Pathway1] = false;
            };
        };
    };
    schema = t.strictInterface({
        currency = t.strictInterface({
            gold = t.number;
        });
        castle = t.strictInterface({
            popularity = t.number;
            unlockedButtons = t.values(t.boolean);
        })
    });
    changedCallbacks = {
        function(userId, newData, oldData)
            local player = Players:GetPlayerByUserId(tonumber(userId):: number)
            if not player then
                return
            end

            DataServerService.PlayerDataChanged:Fire(player, newData, oldData)
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

local dataLoadedCallbacks = {}:: {[Player]: {() -> ()}}

local function playerAdded(player: Player)
    dataLoadedCallbacks[player] = {}
    playerStore:loadAsync(player)

    do
        DataServerService.PlayerDataLoaded:Fire(player)
        table.insert(DataServerService.PlayersLoaded, player)
    end
end

local function playerRemoving(player: Player)
    dataLoadedCallbacks[player] = nil
    playerStore:unloadAsync(player)

    do
        DataServerService.PlayerDataReleased:Fire(player)
        table.remove(
            DataServerService.PlayersLoaded, 
            table.find(
                DataServerService.PlayersLoaded, 
                player
            )
        )
    end
end

function DataServerService.Init()
    -- client handshake, "im ready for data replication!"
    DataSharedService.ClientDataReady.server.OnServerEvent:Connect(function(player)
        DataServerService.PlayerDataChanged:Fire(player, playerStore:getAsync(player))
    end)
    
    -- load data loaded callbacks
    DataServerService.PlayerDataLoaded:Connect(function(player)
        for _, callback in dataLoadedCallbacks[player] do
            callback()
        end
    end)

    -- player added
    do
        for _, player in Players:GetPlayers() do
            playerAdded(player)
        end
        Players.PlayerAdded:Connect(function(player)
            playerAdded(player)
        end)
    end

    -- player removing
    Players.PlayerRemoving:Connect(function(player)
        playerRemoving(player)
    end)

    game:BindToClose(function()
        playerStore:closeAsync()
    end)

    DataServerService.DataServiceInitialized:Fire()
end

function DataServerService.IsPlayerDataLoaded(player: Player): boolean
    return (table.find(DataServerService.PlayersLoaded, player) ~= nil)
end

function DataServerService.OnPlayerDataLoaded(player: Player, loadedCallback: () -> ())
    if DataServerService.IsPlayerDataLoaded(player) then
        loadedCallback()
    else
        if not dataLoadedCallbacks[player] then
            dataLoadedCallbacks[player] = {}
        end

        table.insert(dataLoadedCallbacks[player], loadedCallback)
    end
end

function DataServerService.GetPlayerData(player: Player): PlayerData
    return playerStore:getAsync(player)
end

function DataServerService.SetPlayerData(player: Player, setCallback: (data: PlayerData) -> boolean)
    playerStore:updateAsync(player, function(data)
        return setCallback(data)
    end)
end

return DataServerService
