local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lyra = require(ReplicatedStorage.SharedPackages.Lyra)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local t = require(ReplicatedStorage.SharedPackages.t)
local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local DataServerService = {}

export type CurrencyData = {
    gold: number;
}
export type CastleData = {
    popularity: number;
    --[[
        [structureID -> string]: {isPurchaseable -> boolean, isUnlocked -> boolean}
    ]]
    structureData: {
        --[[
            [structureID -> string]
        ]]
        [string]: 
        --[[
            {isPurchaseable -> boolean, isUnlocked -> boolean}
        ]]
            {boolean};
    }
}
export type PlayerData = {
    currency: CurrencyData;
    castle: CastleData;
}

DataServerService.DataServiceInitialized = Signal.new()
DataServerService.PlayerDataChanged = Signal.new<<(player: Player, newData: PlayerData, oldData: PlayerData?) -> ()>>()
DataServerService.PlayerDataLoaded = Signal.new<<(player: Player) -> ()>>()
DataServerService.PlayerDataReleased = Signal.new<<(player: Player) -> ()>>()

local playerStore = Lyra.createPlayerStore<<PlayerData>>({
    name = "PlayerData";
    template = {
        currency = {
            gold = 10_000;
        };
        castle = {
            popularity = 0;
            structureData = {
                [CastleSharedService.STRUCTURE_NAMES.Pathway1] = {true, false};
            };
        };
    };
    schema = t.strictInterface({
        currency = t.strictInterface({
            gold = t.number;
        });
        castle = t.strictInterface({
            popularity = t.number;
            structureData = t.map(
                t.string,
                t.array(t.boolean)
            );
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

local playersLoaded = {}:: {Player}
local isInitialized = false

local serviceInitializedCallbacks = {}:: {() -> ()}
local playerDataInitalizedCallbacks = {}:: {[Player]: {() -> ()}}

local function playerAdded(player: Player)
    -- sometimes, certain callbacks can trigger before playerAdded() runs here
    if not playerDataInitalizedCallbacks[player] then
        playerDataInitalizedCallbacks[player] = {}
    end
    playerStore:loadAsync(player)

    do
        DataServerService.PlayerDataLoaded:Fire(player)
        table.insert(playersLoaded, player)
    end
end

local function playerRemoving(player: Player)
    playerDataInitalizedCallbacks[player] = nil
    playerStore:unloadAsync(player)

    do
        DataServerService.PlayerDataReleased:Fire(player)
        table.remove(
            playersLoaded, 
            table.find(
                playersLoaded, 
                player
            )
        )
    end
end

local function executeSpawnedCallbacks(callbackList: {() -> ()})
    for _, callback in callbackList do
        task.spawn(function()
            callback()
        end)
    end
end

function DataServerService.Init()
    -- client handshake, "im ready for data replication!"
    DataSharedService.ClientDataReady.server.OnServerEvent:Connect(function(player)
        DataServerService.PlayerDataChanged:Fire(player, playerStore:getAsync(player))
    end)
    
    -- load data loaded callbacks
    DataServerService.PlayerDataLoaded:Connect(function(player)
        executeSpawnedCallbacks(playerDataInitalizedCallbacks[player])
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

    -- execute service initialized
    do
        DataServerService.DataServiceInitialized:Fire()
        isInitialized = true

        executeSpawnedCallbacks(serviceInitializedCallbacks) 
    end
end

function DataServerService.IsServiceInitialized(): boolean
    return isInitialized
end

function DataServerService.OnServiceInitialized(initializedCallback: () -> ())
    if DataServerService.IsServiceInitialized() then
        initializedCallback()
    else
        table.insert(serviceInitializedCallbacks, initializedCallback)
    end
end

function DataServerService.IsPlayerDataInitialized(player: Player): boolean
    return (table.find(playersLoaded, player) ~= nil)
end

function DataServerService.OnPlayerDataInitialized(player: Player, loadedCallback: () -> ())
    if DataServerService.IsPlayerDataInitialized(player) then
        loadedCallback()
    else
        if not playerDataInitalizedCallbacks[player] then
            playerDataInitalizedCallbacks[player] = {}
        end

        table.insert(playerDataInitalizedCallbacks[player], loadedCallback)
    end
end

function DataServerService.GetPlayerDataAsync(player: Player): PlayerData
    return playerStore:getAsync(player)
end

function DataServerService.SetPlayerDataAsync(player: Player, setCallback: (data: PlayerData) -> boolean): boolean
    return playerStore:updateAsync(player, function(data)
        return setCallback(data)
    end)
end

return DataServerService
