local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CurrencyServerService = {}

CurrencyServerService.CURRENCY_TYPES = {
    Gold = "Gold";
}

function CurrencyServerService.CanAffordGold(
    data: DataServerService.PlayerData, 
    cost: number
): boolean
    return data.currency.gold >= cost
end

function CurrencyServerService.IncrementGold(
    data: DataServerService.PlayerData, 
    increment: number
): boolean
    data.currency.gold += increment

    return true
end

return CurrencyServerService
