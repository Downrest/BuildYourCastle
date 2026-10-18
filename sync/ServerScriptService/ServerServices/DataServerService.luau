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

DataServerService.PlayerDataObserved = Signal.new<<(player: Player, newData: PlayerData, oldData: PlayerData?) -> ()>>()
DataServerService.PlayerDataReleased = Signal.new<<(player: Player) -> ()>>()

local playersDataLoaded = {}:: {Player}
local playerStreams = {}:: {[Player]: DataSharedService.PlayerState}

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

			DataServerService.PlayerDataObserved:Fire(player, newData, oldData)
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

local function replicatePlayerState(
	player: Player,
	newData: PlayerData
)
    -- fyi, ...Set() automatically rejects redundant mutations
	local stateReplica = playerStreams[player]

	stateReplica.currency.gold:Set(newData.currency.gold)

	stateReplica.castle.floorUnlocked.floor1:Set(newData.castle.floorUnlocked[DataConfig.FLOOR_NAMES.Floor1])
	stateReplica.castle.floorUnlocked.floor2:Set(newData.castle.floorUnlocked[DataConfig.FLOOR_NAMES.Floor2])
	stateReplica.castle.floorUnlocked.floor3:Set(newData.castle.floorUnlocked[DataConfig.FLOOR_NAMES.Floor3])
	stateReplica.castle.floorUnlocked.floor4:Set(newData.castle.floorUnlocked[DataConfig.FLOOR_NAMES.Floor4])

    stateReplica.castle.tutorialFinished:Set(newData.castle.tutorialFinished)
end

local function playerAdded(player: Player)
	if table.find(playersDataLoaded, player) then
		return
	end

	playerStore:loadAsync(player); do
		local loadedData = DataServerService.GetPlayerDataAsync(player)

		DataServerService.PlayerDataObserved:Fire(player, loadedData)
		replicatePlayerState(player, loadedData)
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

function DataServerService.Init()
	-- data replication
	do
		Players.PlayerAdded:Connect(function(player)
			playerStreams[player] = DataSharedService.PlayerStream:Replica(player)
		end)

		DataServerService.PlayerDataObserved:Connect(function(
			player,
			newData,
			oldData
		)
            replicatePlayerState(player, newData)
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
