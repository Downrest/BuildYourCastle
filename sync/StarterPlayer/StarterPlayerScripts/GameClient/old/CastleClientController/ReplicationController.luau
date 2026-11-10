local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local CastleRenderSharedService = require(ReplicatedStorage.SharedServices.CastleServices.CastleRenderSharedService)
local CastleReplicationSharedService = require(ReplicatedStorage.SharedServices.CastleServices.CastleReplicationSharedService)

local ReplicationController = {}

type PartConfig = {
    parent: Instance;
    cframe: CFrame;

    -- basepart only:
    transparency: number?;
}

local random = Random.new()
local renderCache = {}:: {[CastleRenderSharedService.DefaultStructure]: {
    buttonInstance: Model;
    structureInstances: {Instance};

    particles: {
        purchase: ParticleEmitter;
    };

    partConfig: {[Instance]: PartConfig};
}}

local castleSoundGroup = SoundService.SFX.Castle
local structurePurchaseSound = castleSoundGroup.StructurePurchase

local function cacheRenderAssets(structureAsset: CastleRenderSharedService.DefaultStructure)
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

local function togglePurchasePad(structureAsset: CastleRenderSharedService.DefaultStructure, isStructureUnlocked: boolean)
    local structureRenderCache = renderCache[structureAsset]
    local buttonInstance = structureRenderCache.buttonInstance

    buttonInstance.Parent = isStructureUnlocked
        and CastleRenderSharedService.UNRENDER_CONTAINER 
        or structureRenderCache.partConfig[buttonInstance].parent
end

local function toggleStructureAssets(structureAsset: CastleRenderSharedService.DefaultStructure, isStructureUnlocked: boolean, isAnimated: boolean?)
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
            or CastleRenderSharedService.UNRENDER_CONTAINER
    end
end

local function triggerPurchaseEffects(structureAsset: CastleRenderSharedService.DefaultStructure)
    local structureRenderCache = renderCache[structureAsset]

    structurePurchaseSound:Play()
    structureRenderCache.particles.purchase:Emit(50)
end

local function renderCacheCleanup(structureAsset: CastleRenderSharedService.DefaultStructure)
    renderCache[structureAsset] = nil
end

local function processReplicationBuffer(replicationBuffer: buffer)
    local batchedCastleReplication = CastleReplicationSharedService.DeserializeReplicationPacket(
        replicationBuffer
    )

    for _, castleReplication in batchedCastleReplication do
        CastleRenderSharedService.RenderCastleReplication(castleReplication)
    end
end

function ReplicationController.Init()
    CastleRenderSharedService.InitRender()

    -- TODO CastleRenderSharedService.BuildDecorRendered

    -- structure state + animations
    do
        CastleRenderSharedService.StructureRendered:Connect(function(
            structureAsset,
            structureState
        )
            local isStructureUnlocked = (structureState == CastleRenderSharedService.STRUCTURE_STATES.AlreadyPurchased)
    
            cacheRenderAssets(structureAsset)
    
            togglePurchasePad(structureAsset, isStructureUnlocked)
            toggleStructureAssets(structureAsset, isStructureUnlocked)
        end)
    
        CastleRenderSharedService.StructureStateChanged:Connect(function(
            structureAsset,
            structureState
        )
            local isStructureUnlocked = (structureState == CastleRenderSharedService.STRUCTURE_STATES.AlreadyPurchased)
    
            togglePurchasePad(structureAsset, isStructureUnlocked)
            toggleStructureAssets(structureAsset, isStructureUnlocked, true)
    
            if isStructureUnlocked then
                triggerPurchaseEffects(structureAsset)
    
                -- cleanup, removes asset from rendercache so as to minimize unnecessary memory allocations
                renderCacheCleanup(structureAsset) 
            end
        end)
    end

    -- rendering (structures, builds)
    do
        -- full write initially
        processReplicationBuffer(
            CastleReplicationSharedService.RequestTotalReplicationPackets.client:InvokeServer()
        )
        CastleReplicationSharedService.ReplicationPacket.client.OnClientEvent:Connect(processReplicationBuffer)
    end
end

return ReplicationController
