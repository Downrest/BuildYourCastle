local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CastleRenderSharedService = require(ReplicatedStorage.SharedServices.CastleServices.CastleRenderSharedService)

local ClientPurchaseController = {}

function ClientPurchaseController.Init()
    CastleRenderSharedService.StructurePurchaseTouched:Connect(function(
        unlockedStructureId,
        touchingPlayer
    )
    CastleRenderSharedService.ClientTouchedStructurePurchase.client:FireServer(unlockedStructureId)
    end)
end

return ClientPurchaseController
