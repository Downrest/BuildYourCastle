local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ReplicationController = {}

local random = Random.new()
local renderCache = {}:: {[CastleSharedService.StructureAsset]: {
    buttonInstance: Model;
    structureInstances: {Instance};

    particles: {
        purchase: ParticleEmitter;
    };

    partParentCache: {[Instance]: {
        parent: Instance;
        cframe: CFrame;
    }};
}}

local castleSoundGroup = SoundService.SFX.Castle
local structurePurchaseSound = castleSoundGroup.StructurePurchase

local function cacheRenderAssets(structureAsset: CastleSharedService.StructureAsset)
    local buttonInstance = structureAsset.PurchasePad.Button
    local structureInstances = structureAsset.Assets:QueryDescendants("BasePart")

    local purchaseParticle = structureAsset.PurchaseAttachment.PurchaseParticle

    local partParentCache = {}; do
        partParentCache[buttonInstance:: Instance] = {
            parent = buttonInstance.Parent:: Instance;
            cframe = buttonInstance:GetPivot();
        }

        for _, instance in structureInstances do
            partParentCache[instance:: Instance] = {
                parent = instance.Parent:: Instance;
                cframe = instance.CFrame;
            }
        end
    end

    renderCache[structureAsset] = {
        buttonInstance = buttonInstance;
        structureInstances = structureInstances:: {Instance};

        particles = {
            purchase = purchaseParticle;
        };

        partParentCache = partParentCache;
    }
end

local function togglePurchasePad(structureAsset: CastleSharedService.StructureAsset, isStructureUnlocked: boolean)
    local renderCache = renderCache[structureAsset]
    local buttonInstance = renderCache.buttonInstance

    buttonInstance.Parent = isStructureUnlocked
        and CastleSharedService.UNRENDER_CONTAINER 
        or renderCache.partParentCache[buttonInstance].parent
end

local function toggleStructureAssets(structureAsset: CastleSharedService.StructureAsset, isStructureUnlocked: boolean, isAnimated: boolean?)
    local renderCache = renderCache[structureAsset]
    local structureInstances = renderCache.structureInstances

    for _, instance: BasePart in structureInstances do
        local parentCacheData = renderCache.partParentCache[instance]

        if isAnimated then
            do
                instance.CFrame *= CFrame.new(
                    random:NextInteger(-5, 5),
                    random:NextInteger(0, 5),
                    random:NextInteger(-5, 5)
                )
                instance.Transparency = 1
                instance.CanCollide = false
            end

            local tween = TweenService:Create(
                instance,
                TweenInfo.new(.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut),
                {
                    CFrame = parentCacheData.cframe;
                    Transparency = 0;
                }
            )
            tween:Play()
            tween.Completed:Once(function()
                instance.CanCollide = true
            end)
        end

        instance.Parent = isStructureUnlocked
            and parentCacheData.parent
            or CastleSharedService.UNRENDER_CONTAINER
    end
end

local function triggerPurchaseEffects(structureAsset: CastleSharedService.StructureAsset)
    local renderCache = renderCache[structureAsset]

    structurePurchaseSound:Play()
    renderCache.particles.purchase:Emit(50)
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
        
        if isStructureUnlocked then
            triggerPurchaseEffects(structureAsset)
        end

        togglePurchasePad(structureAsset, isStructureUnlocked)
        toggleStructureAssets(structureAsset, isStructureUnlocked, true)
    end)
end

return ReplicationController
