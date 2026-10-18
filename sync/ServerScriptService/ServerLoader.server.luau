local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local LoaderUtil = require(ReplicatedStorage.SharedUtils.LoaderUtil)

LoaderUtil.scope(function()
	-- SERVICES
	do
		-- shared
		LoaderUtil.Boot(ReplicatedStorage.SharedServices.DataSharedService)
		LoaderUtil.Boot(ReplicatedStorage.SharedServices.CastleSharedService)
		LoaderUtil.Boot(ReplicatedStorage.SharedServices.MapSharedService)
		LoaderUtil.Boot(ReplicatedStorage.SharedServices.NPCSharedService)

		-- server
		LoaderUtil.Require(ServerScriptService.ServerServices.CastleServerService)
		LoaderUtil.Require(ServerScriptService.ServerServices.CommandsServerService)
		LoaderUtil.Require(ServerScriptService.ServerServices.CurrencyServerService)
		LoaderUtil.Require(ServerScriptService.ServerServices.DataServerService)
		LoaderUtil.Require(ServerScriptService.ServerServices.TutorialServerService)
		LoaderUtil.Require(ServerScriptService.ServerServices.TransactionServerService)
	end

	-- CONTROLLERS
	do
		-- pre data
		LoaderUtil.Boot(ServerScriptService.GameServer.CommandsServerController)
		LoaderUtil.Boot(ServerScriptService.GameServer.CastleServerController)
		LoaderUtil.Boot(ServerScriptService.GameServer.CurrencyServerController)

		-- on data
		LoaderUtil.Boot(ServerScriptService.GameServer.DataServerController)
	end
end)
