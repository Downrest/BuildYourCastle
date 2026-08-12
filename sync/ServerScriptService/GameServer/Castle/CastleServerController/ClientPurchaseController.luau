local ServerScriptService = game:GetService("ServerScriptService")

local CastleServerService = require(ServerScriptService.ServerServices.CastleServerService)
local CurrencyServerService = require(ServerScriptService.ServerServices.CurrencyServerService)
local AtomicDataUtil = require(ServerScriptService.ServerUtils.AtomicDataUtil)

local ClientPurchaseController = {}

function ClientPurchaseController.AttemptPurchase(
    player: Player,
    structureID: string
): boolean
    local playerGold = CurrencyServerService.GetGoldAsync(player)
    local structureData = CastleServerService.GetStructureData(structureID)
    local structureGoldCost = structureData.cost.gold

    local success = false

    if 
        (playerGold >= structureGoldCost) 
    then
        warn(`SUCCESS!! AUTOMATICALLLY BUYIN {structureID} FOR {player}`)
        success = CurrencyServerService.IncrementGoldAsync(player, -structureGoldCost, function()
            return AtomicDataUtil.AttemptDataSetters(
                CastleServerService.PurchasePlayerStructure(player, structureID)
            )
        end)
    end

    return success
end

return ClientPurchaseController
