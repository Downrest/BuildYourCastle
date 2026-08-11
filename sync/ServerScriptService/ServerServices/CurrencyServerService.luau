local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CurrencyServerService = {}

function CurrencyServerService.SetGoldAsync(player: Player, goldAmount: number)
    DataServerService.SetPlayerDataAsync(player, function(data)
        data.currency.gold = goldAmount
        return true
    end)
end

function CurrencyServerService.GetGoldAsync(player: Player): number
    local playerData = DataServerService.GetPlayerDataAsync(player)

    return playerData.currency.gold
end

return CurrencyServerService
