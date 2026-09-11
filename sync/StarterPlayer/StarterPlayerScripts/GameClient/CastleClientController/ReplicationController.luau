local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ReplicationController = {}

type PartConfig = {
    parent: Instance;
    cframe: CFrame;

    -- basepart only:
    transparency: number?;
}

local random = Random.new()
local renderCache = {}:: {[CastleSharedService.DefaultStructure]: {
    buttonInstance: Model;
    structureInstances: {Instance};

    particles: {
        purchase: ParticleEmitter;
    };

    partConfig: {[Instance]: PartConfig};
}}

local castleSoundGroup = SoundService.SFX.Castle
local structurePurchaseSound = castleSoundGroup.StructurePurchase

local function cacheRenderAssets(structureAsset: CastleSharedService.DefaultStructure)
	local purchasePad = structureAsset.Constants.PurchasePad
	
	local buttonInstance = purchasePad.Button
    local structureInstances = structureAsset.Assets:QueryDescendants("BasePart")

	local purchaseParticle = purchasePad.Hitbox.PurchaseParticle

    local partConfig: {[Instance]: PartConfig} = {}; do
        partConfig[buttonInstance:: Instance] = {
            parent = buttonInstance.Parent:: Instance;
            cframe = buttonInstance:GetPivot();
        }

		for _, instance: BasePart in structureInstances do
            partConfig[instance] = {
                parent = instance.Parent:: Instance;
                cframe = instance.CFrame;
                transparency = instance.Transparency;
            }
        end
    end

    renderCache[structureAsset] = {
        buttonInstance = buttonInstance;
        structureInstances = structureInstances:: {Instance};

        particles = {
            purchase = purchaseParticle;
        };

        partConfig = partConfig;
    }
end

local function togglePurchasePad(structureAsset: CastleSharedService.DefaultStructure, isStructureUnlocked: boolean)
    local structureRenderCache = renderCache[structureAsset]
    local buttonInstance = structureRenderCache.buttonInstance

    buttonInstance.Parent = isStructureUnlocked
        and CastleSharedService.UNRENDER_CONTAINER 
        or structureRenderCache.partConfig[buttonInstance].parent
end

local function toggleStructureAssets(structureAsset: CastleSharedService.DefaultStructure, isStructureUnlocked: boolean, isAnimated: boolean?)
    local structureRenderCache = renderCache[structureAsset]
    local structureInstances = structureRenderCache.structureInstances

    for _, instance: BasePart in structureInstances do
        local partConfig = structureRenderCache.partConfig[instance]
        local configParent = partConfig.parent
        local configCFrame = partConfig.cframe
        local configTransparency = partConfig.transparency

        if isAnimated then
            do
                instance.CFrame *= CFrame.new(
                    random:NextInteger(-5, 5),
                    random:NextInteger(0, 5),
                    random:NextInteger(-5, 5)
                )
                instance.CanCollide = false
                
                if configTransparency then
                    instance.Transparency = 1
                end
            end

            local tween = TweenService:Create(
                instance,
                TweenInfo.new(.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
                {
                    CFrame = configCFrame;
                    Transparency = configTransparency or 0;
                }
            )
            tween:Play()
            tween.Completed:Once(function()
                instance.CanCollide = true
            end)
        end

        instance.Parent = isStructureUnlocked
            and configParent
            or CastleSharedService.UNRENDER_CONTAINER
    end
end

local function triggerPurchaseEffects(structureAsset: CastleSharedService.DefaultStructure)
    local structureRenderCache = renderCache[structureAsset]

    structurePurchaseSound:Play()
    structureRenderCache.particles.purchase:Emit(50)
end

local function renderCacheCleanup(structureAsset: CastleSharedService.DefaultStructure)
    renderCache[structureAsset] = nil
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

        cacheRenderAssets(structureAsset)

        togglePurchasePad(structureAsset, isStructureUnlocked)
        toggleStructureAssets(structureAsset, isStructureUnlocked)
    end)

    CastleSharedService.StructureStateChanged:Connect(function(
        structureAsset,
        structureState
    )
        local isStructureUnlocked = (structureState == CastleSharedService.STRUCTURE_STATES.AlreadyPurchased)

        togglePurchasePad(structureAsset, isStructureUnlocked)
        toggleStructureAssets(structureAsset, isStructureUnlocked, true)

        if isStructureUnlocked then
            triggerPurchaseEffects(structureAsset)

            -- cleanup, removes asset from rendercache so as to minimize unnecessary memory allocations
            renderCacheCleanup(structureAsset) 
        end
    end)
end

return ReplicationController
