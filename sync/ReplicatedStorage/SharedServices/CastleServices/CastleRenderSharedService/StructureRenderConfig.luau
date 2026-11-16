local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)

local StructureRenderConfig = {}

local castleAssets = AssetSharedService.CASTLE_ASSETS
local castleConstants = castleAssets.Constants

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
    bin: Janitor.Janitor;
}

StructureRenderConfig.ORIGIN_NAMES = {
	PurchaseOrigin = "PurchaseOrigin";
}
StructureRenderConfig.ORIGIN_NAMES_TO_CONSTANT_MODELS = {
	[StructureRenderConfig.ORIGIN_NAMES.PurchaseOrigin] = castleConstants.PurchasePad;
}

StructureRenderConfig.BIN_TAGS = {
	PURCHASE_PAD_TOUCHED = "PurchasePadTouched"
}

StructureRenderConfig.PURCHASE_TOUCHED_DEBOUNCE = .5

return StructureRenderConfig
