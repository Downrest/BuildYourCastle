local ServerScriptService = game:GetService("ServerScriptService")

local CurrencyServerController = require(ServerScriptService.GameServer.Currency.CurrencyServerController)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

DataServerService.DataServiceInitialized:Connect(function()
    CurrencyServerController.Init()
end)
