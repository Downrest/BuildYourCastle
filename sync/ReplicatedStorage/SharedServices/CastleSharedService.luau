local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local Squash = require(ReplicatedStorage.SharedPackages.Squash)
local TypedEvent = require(ReplicatedStorage.SharedPackages.TypedEvent)
local MapSharedService = require(ReplicatedStorage.SharedServices.MapSharedService)
local CleanupUtil = require(ReplicatedStorage.SharedUtils.CleanupUtil)

local CastleSharedService = {}

local castleReplicationSerde = Squash.record({
    castleID = Squash.T(Squash.i8());
    isDestructive = Squash.T(Squash.literal(true, false));
    unlockedStructures = Squash.T(
        -- [structureName -> string]: isUnlocked -> boolean
        Squash.map<<string, boolean>>(
            Squash.string(),
            Squash.literal(true, false)
        )
    );
})
local batchCastleReplicationSerde = Squash.array(castleReplicationSerde);

local lobbyIsland = MapSharedService.LOBBY_ISLAND
local sharedAssets = ReplicatedStorage.SharedAssets
local castleAssets = sharedAssets.Castle
local castleIslandModel = castleAssets.CastleIsland

local castleConstants = castleAssets.Constants
local purchasePadConstant = castleConstants.PurchasePad

local castleProgressions = castleAssets.Progression

local renderContainer
local castleRenderCache = {}:: {[number]: CastleRender}
local purchaseDebounces = {}:: {[string]: boolean}

export type BatchedCastleReplication = {CastleReplication}
export type CastleReplication = {
    castleID: number;
    isDestructive: boolean;
    --[[
        {[structureName -> string]: isUnlocked -> boolean}
    ]]
    unlockedStructures: {[string]: boolean};
}

export type PurchaseConstant = {
	Constants:  {
		PurchasePad: {
			Button: Model & {
				Base: BasePart;
				Button: BasePart & {
					PriceAttachment: Attachment & {
						BillboardGui: BillboardGui & {
							Frame: Frame & {
								GoldCost: TextLabel;
								GoldIcon: ImageLabel;
							}
						}
					};
					TitleAttachment: Attachment & {
						BillboardGui: BillboardGui & {
							Frame: Frame & {
								Title: TextLabel;
							}
						}
					}
				};
			};
			Hitbox: BasePart & {
				PurchaseParticle: ParticleEmitter;
			};
		};
    };
	Origins: {
        PurchaseOrigin: BasePart;
    };
}
export type GenericStructure = Model & {
    Assets: Instance;

    Constants: {};
	Origins: {};
}
export type DefaultStructure = GenericStructure
    & PurchaseConstant

export type StructureRenderData = {
    asset: DefaultStructure;
    state: string;
    bin: {CleanupUtil.Trash?};
}
export type CastleRender = {
	castleIslandModel: typeof(castleIslandModel);
    unlockedRenderStructures: {
        [string]: StructureRenderData
    };
}

CastleSharedService.UNRENDER_CONTAINER = script.Unrendered
CastleSharedService.STRUCTURE_NAMES = {
	Pathway1 = "Pathway1";
}
CastleSharedService.STRUCTURE_NAME_TO_ASSET = {
    [CastleSharedService.STRUCTURE_NAMES.Pathway1] = castleProgressions["1. Pathway (10)"];
}
CastleSharedService.STRUCTURE_STATES = {
    ToPurchase = "ToPurchase";
    AlreadyPurchased = "AlreadyPurchased";
}
CastleSharedService.STRUCTURE_CONFIG_DATA = {
	[CastleSharedService.STRUCTURE_NAMES.Pathway1] = {
		title = "Pathway";
		cost = {
			gold = 30;   
		};
	}
}

CastleSharedService.ClientReplicationReady =
    TypedEvent.newReliable("ClientReplicationReady"):: TypedEvent.ClientToServer<any>
CastleSharedService.ReplicationPacket =
    TypedEvent.newReliable("ReplicationPacket"):: TypedEvent.ServerToClient<(replicationBuffer: buffer) -> ()>

CastleSharedService.ClientTouchedStructurePurchase =
    TypedEvent.newReliable("ClientTouchedStructurePurchase"):: TypedEvent.ClientToServer<(structureID: string) -> ()>
CastleSharedService.ServerPurchaseStatus =
    TypedEvent.newReliable("ServerPurchaseStatus"):: TypedEvent.ServerToClient<(purchaseSuccess: boolean) -> ()>

CastleSharedService.StructurePurchaseTouched = 
    Signal.new<<(structureID: string, touchingPlayer: Player) -> ()>>()
CastleSharedService.StructureRendered = 
    Signal.new<<(structureAsset: DefaultStructure, currentState: string) -> ()>>()
CastleSharedService.StructureStateChanged = 
    Signal.new<<(structureAsset: DefaultStructure, newState: string, oldState: string) -> ()>>()

local CASTLE_ID_DATA = {
    [1] = {
        cframe = lobbyIsland:GetPivot()
            * CFrame.Angles(0, math.rad(-90), 0)
    };
    [2] = {
        cframe = lobbyIsland:GetPivot()
            * CFrame.Angles(0, math.rad(0), 0)
    };
    [3] = {
        cframe = lobbyIsland:GetPivot()
            * CFrame.Angles(0, math.rad(90), 0)
    };
    [4] = {
        cframe = lobbyIsland:GetPivot()
            * CFrame.Angles(0, math.rad(180), 0)
    };
}
local ORIGIN_NAMES = {
    PurchaseOrigin = "PurchaseOrigin";
}
local ORIGIN_NAMES_TO_CONSTANT_MODELS = {
    [ORIGIN_NAMES.PurchaseOrigin] = castleConstants.PurchasePad;
}
local BIN_TAGS = {
    PURCHASE_PAD_TOUCHED = "PurchasePadTouched"
}
local PURCHASE_TOUCHED_DEBOUNCE = .5

function CastleSharedService.SerializeReplicationPacket(batchCastleReplication: BatchedCastleReplication): buffer
    warn("ATTEMPT TO SERIALIZE!!!! ", batchCastleReplication)

    local cursor = Squash.cursor()

    batchCastleReplicationSerde.ser(cursor, batchCastleReplication)

    return Squash.tobuffer(cursor)
end

function CastleSharedService.DeserializeReplicationPacket(replicationBuffer: buffer): BatchedCastleReplication
    warn("ATTEMPT TO DESERIALIZE!!!! ", replicationBuffer)

    local cursor = Squash.frombuffer(replicationBuffer)

    return batchCastleReplicationSerde.des(cursor)
end

function CastleSharedService.InitRender(preventReplication: boolean?)
    if preventReplication then
        renderContainer = Instance.new("Camera"); do
            renderContainer.Parent = MapSharedService.PLAYER_ISLAND_CONTAINER
        end
    else
        renderContainer = MapSharedService.PLAYER_ISLAND_CONTAINER
    end
end

function CastleSharedService.GetRenderCastle(castleID: number): CastleRender
    return castleRenderCache[castleID]
end

function CastleSharedService.RenderCastleReplication(castleReplication: CastleReplication)
    warn(`REPLICATING... `, castleReplication)
    assert(renderContainer, "Attempted to render castle replication without renderContainer!")

    local castleRender = CastleSharedService.GetRenderCastle(castleReplication.castleID); do
        if not castleRender then
            -- cache castle render data + render island if necessary
            do
                local castleCFrame = CASTLE_ID_DATA[castleReplication.castleID].cframe
                local castleIslandModel = castleIslandModel:Clone(); do
                    castleIslandModel:PivotTo(castleCFrame)
                    castleIslandModel.Parent = renderContainer
                end
    
                local newCastleRender = {
                    castleIslandModel = castleIslandModel;
                    unlockedRenderStructures = {};
                }
                castleRenderCache[castleReplication.castleID] = newCastleRender:: CastleRender
    
                castleRender = castleRenderCache[castleReplication.castleID]
            end
        end 
    end

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
                and CastleSharedService.STRUCTURE_STATES.AlreadyPurchased
                or CastleSharedService.STRUCTURE_STATES.ToPurchase

            -- change existing structure state
            if unlockedStructureData then
                local previousState = unlockedStructureData.state
                local structureBin = unlockedStructureData.bin

                if unlockedStructureData.state ~= currentState then
                    unlockedStructureData.state = currentState
                    CastleSharedService.StructureStateChanged:Fire(
                        unlockedStructureData.asset,
                        currentState,
                        previousState
                    )

                    CleanupUtil.Clean(structureBin, BIN_TAGS.PURCHASE_PAD_TOUCHED)
                    purchaseDebounces[unlockedStructureID] = nil
                end

            -- create new structure + state
            else
                local STRUCTURE_ASSET = CastleSharedService.STRUCTURE_NAME_TO_ASSET[unlockedStructureID]

				local structureModel: DefaultStructure = (STRUCTURE_ASSET:Clone():: any); do
                    structureModel:PivotTo(castleRender.castleIslandModel:GetPivot())
                    structureModel.Parent = castleRender.castleIslandModel.Progression
				end
				local structureConfig = CastleSharedService.STRUCTURE_CONFIG_DATA[unlockedStructureID]
                local structureBin = {}

				-- create constants available to structure
				do
					for _, originInstance in (structureModel.Origins:: Instance):GetChildren() do
                        local originName = originInstance.Name

						-- purchase pad
						if originName == ORIGIN_NAMES.PurchaseOrigin then
							purchaseDebounces[unlockedStructureID] = false
							
							local purchasePad = ORIGIN_NAMES_TO_CONSTANT_MODELS[originName]; do
								local purchaseOrigin = structureModel.Origins.PurchaseOrigin
								
								purchasePad:PivotTo(purchaseOrigin.CFrame)
								purchasePad.Parent = (structureModel.Constants:: Instance)
							end
							
							local hitboxPart = purchasePad.Hitbox
							local buttonPart = purchasePad.Button.Button
							local priceGui = buttonPart.PriceAttachment.BillboardGui
							local priceFrame = priceGui.Frame
							local goldCostText = priceFrame.GoldCost
							local titleGui = buttonPart.TitleAttachment.BillboardGui
							local titleFrame = titleGui.Frame
							local titleText = titleGui.Frame.Title
							
							-- sync title + cost billboard values to structure ID config
							do
								titleText.Text = `{structureConfig.title}`
								
								goldCostText.Text = `{structureConfig.cost.gold}`
							end

							-- purchase pad touched
							CleanupUtil.InsertBin(structureBin, 
								hitboxPart.Touched:Connect(function(part)
									if purchaseDebounces[unlockedStructureID] then
										return
									end

									local character = part:FindFirstAncestorWhichIsA("Model")
									local player = character and Players:GetPlayerFromCharacter(character)
									if not player then
										return
									end

									purchaseDebounces[unlockedStructureID] = true
									task.delay(PURCHASE_TOUCHED_DEBOUNCE, function()
										purchaseDebounces[unlockedStructureID] = false
									end)

									CastleSharedService.StructurePurchaseTouched:Fire(unlockedStructureID, player)

								end), BIN_TAGS.PURCHASE_PAD_TOUCHED
							)
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

                    CastleSharedService.StructureRendered:Fire(
                        unlockedStructureData.asset:: any,
                        currentState
                    )
                end
            end
        end
    end
end

return CastleSharedService
