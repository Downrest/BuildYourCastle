local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CurrencyServerService = {}

function CurrencyServerService.SetGold(player: Player, goldAmount: number)
    DataServerService.SetPlayerData(player, function(data)
        data.currency.gold = goldAmount
        return true
    end)
end

function CurrencyServerService.GetGold(player: Player): number
    local playerData = DataServerService.GetPlayerData(player)

    return playerData.currency.gold
end

return CurrencyServerService
