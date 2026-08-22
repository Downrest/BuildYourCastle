local ServerScriptService = game:GetService("ServerScriptService")

local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local CurrencyServerService = require(ServerScriptService.ServerServices.CurrencyServerService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local PurchaseServerService = {}

function PurchaseServerService.PurchaseCastleStructure(player: Player, structureID: string): boolean
    return DataServerService.SetPlayerDataAsync(player, function(data)
        local structureConfig = CastleServerService.GetStructureConfig(structureID); do
            assert(structureConfig, `Structure ID {structureID} has no structure config?`)
        end
        local structureCost = structureConfig.cost.gold
        
        -- conditional flags
        do
            if not CurrencyServerService.CanAffordGold(data, structureCost) then
                return false
            end
            assert(CastleServerService.IsStructureUnlockable(data, structureID), `{player} cannot unlock structure ID {structureID}`)
        end

        -- process data mutation
        do
            local goldIncrementSuccess = CurrencyServerService.IncrementGold(data, -structureCost)
            local structureUnlockSuccess = CastleServerService.UnlockStructure(data, structureID)

            return 
                goldIncrementSuccess 
                and structureUnlockSuccess
        end
    end)
end

return PurchaseServerService
