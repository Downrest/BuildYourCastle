local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ClientPurchaseController = {}

function ClientPurchaseController.Init()
    CastleSharedService.StructurePurchaseTouched:Connect(function(
        unlockedStructureId,
        touchingPlayer
    )
        warn(`TOUCH STRUCTURE ID.... {unlockedStructureId}`)
        CastleSharedService.ClientTouchedStructurePurchase.client:FireServer(unlockedStructureId)
    end)
end

return ClientPurchaseController
