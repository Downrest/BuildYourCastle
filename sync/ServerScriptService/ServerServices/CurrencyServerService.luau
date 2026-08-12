local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CurrencyServerService = {}

function CurrencyServerService.SetGoldAsync(player: Player, goldAmount: number, atomicCallback: () -> boolean): boolean
    return DataServerService.SetPlayerDataAsync(player, function(data)
        local successBoolean = atomicCallback()

        data.currency.gold = goldAmount

        return successBoolean
    end)
end

function CurrencyServerService.IncrementGoldAsync(player: Player, goldIncrement: number, atomicCallback: () -> boolean): boolean
    return DataServerService.SetPlayerDataAsync(player, function(data)
        local successBoolean = atomicCallback()

        data.currency.gold += goldIncrement

        return successBoolean
    end)
end

function CurrencyServerService.GetGoldAsync(player: Player): number
    local playerData = DataServerService.GetPlayerDataAsync(player)

    return playerData.currency.gold
end

return CurrencyServerService
