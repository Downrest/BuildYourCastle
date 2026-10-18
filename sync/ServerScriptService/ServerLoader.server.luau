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
        LoaderUtil.Boot(ServerScriptService.ServerServices.CastleServerService, true)
        LoaderUtil.Boot(ServerScriptService.ServerServices.CommandsServerService, true)
        LoaderUtil.Boot(ServerScriptService.ServerServices.CurrencyServerService, true)
        LoaderUtil.Boot(ServerScriptService.ServerServices.DataServerService, true)
        LoaderUtil.Boot(ServerScriptService.ServerServices.TutorialServerService, true)
        LoaderUtil.Boot(ServerScriptService.ServerServices.TransactionServerService, true)
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
