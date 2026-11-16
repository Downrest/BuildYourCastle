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

			warn(`{player} WENT FROM`, oldData, `TO`, newData)
			if newData then
				DataServerService.PlayerDataObserved:Fire(player, newData, oldData)
			else
				DataServerService.PlayerDataReleased:Fire(player)
			end
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
	local currencyData = newData.currency
	local castleData = newData.castle

	-- fyi, ...Set() automatically rejects redundant mutations
	local stateReplica = playerStreams[player]
	local currencyReplica = stateReplica.currency
	local castleReplica = stateReplica.castle

	stateReplica.gameFirstlyIntroduced:Set(newData.gameFirstlyIntroduced)

	-- currency
	do
		currencyReplica.gold:Set(currencyData.gold)
	end

	-- castle
	do
		castleReplica.id:Set(castleData.id)

		castleReplica.floorUnlocked.floor1:Set(castleData.floorUnlocked[DataConfig.FLOOR_NAMES.Floor1])
		castleReplica.floorUnlocked.floor2:Set(castleData.floorUnlocked[DataConfig.FLOOR_NAMES.Floor2])
		castleReplica.floorUnlocked.floor3:Set(castleData.floorUnlocked[DataConfig.FLOOR_NAMES.Floor3])
		castleReplica.floorUnlocked.floor4:Set(castleData.floorUnlocked[DataConfig.FLOOR_NAMES.Floor4])

		castleReplica.tutorialFinished:Set(castleData.tutorialFinished)
	end
end

local function onPlayerAdded(callback: (player: Player) -> ())
	for _, player in Players:GetPlayers() do
		callback(player)
	end

	Players.PlayerAdded:Connect(callback)
end

local function onPlayerRemoving(callback: (player: Player, exitReason: Enum.PlayerExitReason) -> ())
	Players.PlayerRemoving:Connect(callback)
end

function DataServerService.Init()
	-- data replication
	do
		DataServerService.PlayerDataObserved:Connect(function(
			player,
			newData,
			oldData
		)
			replicatePlayerState(player, newData)
		end)
	end

	onPlayerAdded(function(player: Player)
		-- replicate shared gamestate
		do
			playerStreams[player] = DataSharedService.PlayerStream:Replica(player)
		end

		-- load server playerstate
		do
			playerStore:loadAsync(player); do
				table.insert(playersDataLoaded, player)
			end
		end
	end)

	onPlayerRemoving(function(player: Player)
		assert(table.find(playersDataLoaded, player), "Player was not loaded initially? Must be a bug")

		-- unload + save server playerstate
		do
			playerStore:unloadAsync(player); do
				table.remove(playersDataLoaded, table.find(playersDataLoaded, player))
			end
		end
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
