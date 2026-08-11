local ServerScriptService = game:GetService("ServerScriptService")

local CurrencyServerController = require(ServerScriptService.GameServer.Currency.CurrencyServerController)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

DataServerService.OnServiceInitialized(function()
    CurrencyServerController.Init()
end)
