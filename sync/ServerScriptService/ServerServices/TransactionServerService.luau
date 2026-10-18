local ServerScriptService = game:GetService("ServerScriptService")

local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local CurrencyServerService = require(ServerScriptService.ServerServices.CurrencyServerService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local TransactionServerService = {}

function TransactionServerService.FinishTutorial(player: Player): boolean
    return DataServerService.SetPlayerDataAsync(player, function(data)
        data.castle.tutorialFinished = true

        return true
    end)
end

function TransactionServerService.PurchaseCastleStructure(player: Player, structureID: string): boolean
    return DataServerService.SetPlayerDataAsync(player, function(data)
        local structureConfig = CastleServerService.GetStructureConfig(structureID); do
            assert(structureConfig, `Structure ID {structureID} has no structure config?`)
        end
        local structureCost = structureConfig.cost.gold
        
        -- conditional flags
        do
            if not CurrencyServerService.CanAffordGold(player, data, structureCost) then
                return false
            end
            assert(CastleServerService.IsStructureUnlockable(player, data, structureID), `{player} cannot unlock structure ID {structureID}`)
        end

        do
            local goldIncrementSuccess = CurrencyServerService.IncrementGold(player, data, -structureCost)
            local structureUnlockSuccess = CastleServerService.UnlockStructure(player, data, structureID)

            return 
                goldIncrementSuccess 
                and structureUnlockSuccess
        end
    end)
end

return TransactionServerService
