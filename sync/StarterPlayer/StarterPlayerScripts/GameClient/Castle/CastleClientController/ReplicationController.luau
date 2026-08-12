local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ReplicationController = {}

-- TODO: both of these functions are placeholders btw, better implementation soon
local function togglePurchasePad(structureAsset: CastleSharedService.StructureAsset, isStructureUnlocked: boolean)
    local buttonContainer = structureAsset.PurchasePad.Button

    local purchasePadParts = buttonContainer:QueryDescendants("BasePart"); do
        for _, part in purchasePadParts do
            part.Transparency = isStructureUnlocked and 1 or 0
        end
    end

    local purchasePadGuis = buttonContainer:QueryDescendants("BillboardGui"); do
        for _, gui in purchasePadGuis do
            gui.Enabled = not isStructureUnlocked
        end
    end
end
local function toggleStructureAssets(structureAsset: CastleSharedService.StructureAsset, isStructureUnlocked: boolean)
    local structureParts = structureAsset.Assets:QueryDescendants("BasePart"); do
        for _, part in structureParts do
            part.Transparency = isStructureUnlocked and 0 or 1
        end
    end

    local structureTextures = structureAsset.Assets:QueryDescendants("Texture"); do
        for _, texture in structureTextures do
            texture.Transparency = isStructureUnlocked and 0 or 1
        end
    end
end

function ReplicationController.Init()
    CastleSharedService.InitRender()
    CastleSharedService.ClientReplicationReady.client:FireServer()
    
    CastleSharedService.ReplicationPacket.client.OnClientEvent:Connect(function(
        replicationBuffer
    )
        local batchedCastleReplication = CastleSharedService.DeserializeReplicationPacket(
            replicationBuffer
        )

        for _, castleReplication in batchedCastleReplication do
            CastleSharedService.RenderCastleReplication(castleReplication)
        end
    end)

    CastleSharedService.StructureRendered:Connect(function(
        structureAsset,
        structureState
    )
        local isStructureUnlocked = (structureState == CastleSharedService.STRUCTURE_STATES.AlreadyPurchased)

        togglePurchasePad(structureAsset, isStructureUnlocked)
        toggleStructureAssets(structureAsset, isStructureUnlocked)
    end)

    CastleSharedService.StructureStateChanged:Connect(function(
        structureAsset,
        structureState
    )
        local isStructureUnlocked = (structureState == CastleSharedService.STRUCTURE_STATES.AlreadyPurchased)

        togglePurchasePad(structureAsset, isStructureUnlocked)
        toggleStructureAssets(structureAsset, isStructureUnlocked)
    end)
end

return ReplicationController
