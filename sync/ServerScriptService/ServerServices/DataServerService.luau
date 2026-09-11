local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lyra = require(ReplicatedStorage.SharedPackages.Lyra)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)
local DataConfig = require(script.DataConfig)

local DataServerService = {}

export type CurrencyData = DataConfig.CurrencyData

export type CastleStructureData = DataConfig.CastleStructureData
export type CastleData = DataConfig.CastleData

export type PlayerData = DataConfig.PlayerData

DataServerService.DataServiceInitialized = Signal.new()
DataServerService.PlayerDataChanged = Signal.new<<(player: Player, newData: PlayerData, oldData: PlayerData?) -> ()>>()
DataServerService.PlayerDataLoaded = Signal.new<<(player: Player, loadedData: PlayerData) -> ()>>()
DataServerService.PlayerClientHandshaked = Signal.new<<(player: Player, loadedData: PlayerData) -> ()>>()
DataServerService.PlayerDataReleased = Signal.new<<(player: Player) -> ()>>()

local playersDataLoaded = {}:: {Player}
local playersClientHandshaked = {}:: {Player}
local playerReplicationData = {}:: {[Player]: DataSharedService.ReplicatedData}

local playerStore = Lyra.createPlayerStore<<PlayerData>>({
    name = "PlayerData";
    template = DataConfig.DATA_TEMPLATE;
    schema = DataConfig.DATA_SCHEMA;
    changedCallbacks = {
        function(userId, newData, oldData)
            local player = Players:GetPlayerByUserId(tonumber(userId):: number); do 
                assert(player, `Failed to translate {userId} into player?`)
            end

            if not table.find(playersDataLoaded, player) then
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

local function playerAdded(player: Player)
    if table.find(playersDataLoaded, player) then
        return
    end

    playerStore:loadAsync(player); do
        local loadedData = DataServerService.GetPlayerDataAsync(player)

        DataServerService.PlayerDataLoaded:Fire(player, loadedData)
        table.insert(playersDataLoaded, player)
    end
end

local function playerRemoving(player: Player)
    assert(table.find(playersDataLoaded, player), "Player was not loaded initially? Must be a bug")

    playerStore:unloadAsync(player); do
        DataServerService.PlayerDataReleased:Fire(player)
        table.remove(playersDataLoaded, table.find(playersDataLoaded, player))
    end
end

local function replicateData(
    player: Player,
    newData: PlayerData,
    oldData: PlayerData?
)
    local replicationData = playerReplicationData[player]; do
        assert(replicationData, `No replicatedData for {player}?`)
    end
    local attributes = replicationData.attributes

    warn(`CHANGED DATA..... old `, oldData, `vs new `, newData)

    -- gold
    if not oldData or newData.currency.gold ~= oldData.currency.gold then
        warn(`NEW GOLD DATA`)
        attributes.currency.gold:Set(newData.currency.gold)
	end
	
    -- unlocked floor
    if not oldData or newData.castle.floorUnlocked ~= oldData.castle.floorUnlocked then
        warn(`HELLO????? NEW FLOOR DATA`)
        attributes.castle.floorUnlocked.floor1:Set(newData.castle.floorUnlocked[DataConfig.FLOOR_NAMES.Floor1])
        attributes.castle.floorUnlocked.floor2:Set(newData.castle.floorUnlocked[DataConfig.FLOOR_NAMES.Floor2])
        attributes.castle.floorUnlocked.floor3:Set(newData.castle.floorUnlocked[DataConfig.FLOOR_NAMES.Floor3])
        attributes.castle.floorUnlocked.floor4:Set(newData.castle.floorUnlocked[DataConfig.FLOOR_NAMES.Floor4])
    end

    -- finished tutorial
    if not oldData or newData.castle.tutorialFinished ~= oldData.castle.tutorialFinished then
        attributes.castle.tutorialFinished:Set(newData.castle.tutorialFinished)
    end
end

function DataServerService.Init()
    -- client handshake, "im ready for data replication!"
    DataSharedService.ClientDataReady.server.OnServerEvent:Connect(function(player)
        if table.find(playersClientHandshaked, player) then
            return
        end

        table.insert(playersClientHandshaked, player)

        local loadedData = playerStore:getAsync(player); do
            replicateData(player, loadedData)
            DataServerService.PlayerClientHandshaked:Fire(player, loadedData)
        end
        warn("BRO IS READY FOR CLIENT DATA CHANGES!!")
    end)

    -- data replication
    do
        DataSharedService.PlayerDataInitialized:Connect(function(
            player,
            replicationData
        )
            playerReplicationData[player] = replicationData
        end)

        DataServerService.PlayerDataChanged:Connect(function(
            player,
            newData,
            oldData
        )
            if not DataServerService.HasPlayerClientHandshaked(player) then
                return
            end

            replicateData(player, newData, oldData)
        end)
    end

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

    -- game close
    game:BindToClose(function()
        playerStore:closeAsync()
    end)

    -- execute service initialized
    DataServerService.DataServiceInitialized:Fire()
end

function DataServerService.GetPlayerDataAsync(player: Player): PlayerData
    return playerStore:getAsync(player)
end

function DataServerService.SetPlayerDataAsync(player: Player, setCallback: (data: PlayerData) -> boolean): boolean
    return playerStore:updateAsync(player, function(data)
        return setCallback(data)
    end)
end

function DataServerService.HasPlayerClientHandshaked(player: Player): boolean
    return (table.find(playersClientHandshaked, player) ~= nil)
end

return DataServerService
