local ServerScriptService = game:GetService("ServerScriptService")

local CurrencyServerController = require(ServerScriptService.GameServer.Currency.CurrencyServerController)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

DataServerService.DataServiceInitialized:Once(function()
    CurrencyServerController.Init()
end)
