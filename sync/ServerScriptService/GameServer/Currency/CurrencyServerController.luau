local ServerScriptService = game:GetService("ServerScriptService")

local CurrencyServerService = require(ServerScriptService.ServerServices.CurrencyServerService)

local CurrencyServerController = {}

function CurrencyServerController.Init()
    CurrencyServerService.Init()
end

return CurrencyServerController
