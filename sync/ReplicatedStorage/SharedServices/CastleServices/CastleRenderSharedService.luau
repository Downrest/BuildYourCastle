local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StructureConfig = require(ReplicatedStorage.SharedConfigs.CastleConfig.StructureConfig)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local TypedRemote = require(ReplicatedStorage.SharedPackages.TypedRemote)

local MapSharedService = require(ReplicatedStorage.SharedServices.MapSharedService)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local CastleReplicationSharedService = require(ReplicatedStorage.SharedServices.CastleServices.CastleReplicationSharedService)
local CastleRenderConfig = require(script.CastleRenderConfig)
local StructureRenderConfig = require(script.StructureRenderConfig)

local CastleRenderSharedService = {}

export type PurchaseConstant = StructureRenderConfig.PurchaseConstant
export type GenericStructure = StructureRenderConfig.GenericStructure
export type DefaultStructure = StructureRenderConfig.DefaultStructure
export type StructureRenderData = StructureRenderConfig.StructureRenderData

export type CastleRender = CastleRenderConfig.CastleRenderData

local renderContainer
local castleRenderCache = {}:: {[number]: CastleRender}
local purchaseDebounces = {}:: {[string]: boolean}

CastleRenderSharedService.ClientTouchedStructurePurchase =
    TypedRemote.newReliableEvent("ClientTouchedStructurePurchase"):: TypedRemote.ToServerEvent<(structureID: string) -> ()>
CastleRenderSharedService.ServerPurchaseStatus =
    TypedRemote.newReliableEvent("ServerPurchaseStatus"):: TypedRemote.ToClientEvent<(purchaseSuccess: boolean) -> ()>

CastleRenderSharedService.StructurePurchaseTouched = 
    Signal.new<<(structureID: string, touchingPlayer: Player) -> ()>>()
CastleRenderSharedService.StructureRendered = 
    Signal.new<<(structureAsset: DefaultStructure, currentState: string) -> ()>>()
CastleRenderSharedService.StructureStateChanged = 
    Signal.new<<(structureAsset: DefaultStructure, newState: string, oldState: string) -> ()>>()

CastleRenderSharedService.FLOOR_NAMES = StructureConfig.FLOOR_NAMES
CastleRenderSharedService.FLOOR_END_STRUCTURES = StructureConfig.FLOOR_END_STRUCTURES

CastleRenderSharedService.STRUCTURE_NAMES = StructureConfig.STRUCTURE_NAMES
CastleRenderSharedService.STRUCTURE_NAME_TO_ASSET = StructureConfig.STRUCTURE_NAME_TO_ASSET
CastleRenderSharedService.STRUCTURE_CONFIG_DATA = StructureConfig.STRUCTURE_CONFIG_DATA
CastleRenderSharedService.UNRENDER_CONTAINER = script.Unrendered
CastleRenderSharedService.STRUCTURE_STATES = {
    ToPurchase = "ToPurchase";
    AlreadyPurchased = "AlreadyPurchased";
}

local function loadRenderCastle(castleReplication: CastleReplicationSharedService.CastleReplication): CastleRender
    local castleRender = castleRenderCache[castleReplication.castleID]
    if not castleRender then
        local castleRenderData = CastleRenderConfig.CASTLE_ID_DATA[castleReplication.castleID]; do
            assert(castleRenderData)
        end
        local castleCFrame = castleRenderData.cframe
        local castleIslandModel = CastleRenderConfig.CASTLE_ISLAND_MODEL:Clone(); do
            castleIslandModel:PivotTo(castleCFrame)
            castleIslandModel.Parent = renderContainer:: any
        end

        castleRender = {
            castleIslandModel = castleIslandModel;
            unlockedRenderStructures = {};
        }
        castleRenderCache[castleReplication.castleID] = castleRender
    end

    return castleRender
end

function CastleRenderSharedService.InitRender(preventReplication: boolean?)
    if preventReplication then
        renderContainer = Instance.new("Camera"); do
            renderContainer.Parent = MapSharedService.PLAYER_ISLAND_CONTAINER
        end
    else
        renderContainer = MapSharedService.PLAYER_ISLAND_CONTAINER
    end
end

function CastleRenderSharedService.GetCastleIslandSize(): Vector3
    return CastleRenderConfig.CASTLE_ISLAND_SIZE
end

function CastleRenderSharedService.GetCastleIslandCFrame(castleID: number): CFrame
    local castleRenderData = CastleRenderConfig.CASTLE_ID_DATA[castleID]; do
        assert(castleRenderData)
    end

    return castleRenderData.cframe
end

function CastleRenderSharedService.GetStructureConfig(structureID: string): StructureConfig.StructureConfig
    return CastleRenderSharedService.STRUCTURE_CONFIG_DATA[structureID]:: StructureConfig.StructureConfig
end

function CastleRenderSharedService.RenderCastleReplication(castleReplication: CastleReplicationSharedService.CastleReplication)
    assert(renderContainer, "Attempted to render castle replication without renderContainer!")

    local castleRender = loadRenderCastle(castleReplication)

    -- render structures
    do
        -- if destructive, clear every existing asset, let new data override
        if castleReplication.isDestructive then
            for structureID, structureData in castleRender.unlockedRenderStructures do
                local asset = structureData.asset; do
                    asset:Destroy()
                end

                castleRender.unlockedRenderStructures[structureID] = nil
            end
        end

        for unlockedStructureID, isUnlocked in castleReplication.unlockedStructures do
            local unlockedStructureData = castleRender.unlockedRenderStructures[unlockedStructureID]
            local currentState = isUnlocked
                and CastleRenderSharedService.STRUCTURE_STATES.AlreadyPurchased
                or CastleRenderSharedService.STRUCTURE_STATES.ToPurchase

            -- change existing structure state
            if unlockedStructureData then
                local previousState = unlockedStructureData.state
                local structureBin = unlockedStructureData.bin

                if unlockedStructureData.state ~= currentState then
                    unlockedStructureData.state = currentState
                    CastleRenderSharedService.StructureStateChanged:Fire(
                        unlockedStructureData.asset,
                        currentState,
                        previousState
                    )

                    structureBin:Remove(StructureRenderConfig.BIN_TAGS.PURCHASE_PAD_TOUCHED)
                    purchaseDebounces[unlockedStructureID] = nil
                end

            -- create new structure + state
            else
                local STRUCTURE_ASSET = CastleRenderSharedService.STRUCTURE_NAME_TO_ASSET[unlockedStructureID]

				local structureModel: DefaultStructure = (STRUCTURE_ASSET:Clone():: any); do
                    structureModel:PivotTo(castleRender.castleIslandModel:GetPivot())
                    structureModel.Parent = castleRender.castleIslandModel.Progression
				end
				local structureConfig = CastleRenderSharedService.STRUCTURE_CONFIG_DATA[unlockedStructureID]
                local structureBin = Janitor.new()

				-- create constants available to structure
				do
					for _, originInstance in (structureModel.Origins:: any):GetChildren() do
                        local originName = originInstance.Name

						-- purchase pad
						if originName == StructureRenderConfig.ORIGIN_NAMES.PurchaseOrigin then
							purchaseDebounces[unlockedStructureID] = false
							
							local purchasePad = StructureRenderConfig.ORIGIN_NAMES_TO_CONSTANT_MODELS[originName]:Clone(); do
								local purchaseOrigin = structureModel.Origins.PurchaseOrigin
								
								purchasePad:PivotTo(purchaseOrigin.CFrame)
								purchasePad.Parent = (structureModel.Constants:: any)
							end
							
							local hitboxPart = purchasePad.Hitbox
							local buttonPart = purchasePad.Button.Button
							local priceGui = buttonPart.PriceAttachment.BillboardGui
							local priceFrame = priceGui.Frame
							local goldCostText = priceFrame.GoldCost
							local titleGui = buttonPart.TitleAttachment.BillboardGui
							local titleFrame = titleGui.Frame
							local titleText = titleFrame.Title
							
							-- sync title + cost billboard values to structure ID config
							do
								titleText.Text = `{structureConfig.title}`
								goldCostText.Text = `{structureConfig.cost.gold}`
							end

							-- purchase pad touched
							structureBin:Add(hitboxPart.Touched:Connect(function(part)
                                if purchaseDebounces[unlockedStructureID] then
                                    return
                                end

                                local character = part:FindFirstAncestorWhichIsA("Model")
                                local player = character and Players:GetPlayerFromCharacter(character)
                                if not player then
                                    return
                                end

                                purchaseDebounces[unlockedStructureID] = true
                                task.delay(StructureRenderConfig.PURCHASE_TOUCHED_DEBOUNCE, function()
                                    purchaseDebounces[unlockedStructureID] = false
                                end)

                                CastleRenderSharedService.StructurePurchaseTouched:Fire(unlockedStructureID, player)
                            end), nil, StructureRenderConfig.BIN_TAGS.PURCHASE_PAD_TOUCHED)
						end
					end
				end

                -- update state
				do
					unlockedStructureData = {
						asset = structureModel;
						state = currentState;
						bin = structureBin;
					}
                    castleRender.unlockedRenderStructures[unlockedStructureID] = unlockedStructureData:: any

                    CastleRenderSharedService.StructureRendered:Fire(
                        unlockedStructureData.asset:: any,
                        currentState
                    )
                end
            end
        end
    end
end

return CastleRenderSharedService
