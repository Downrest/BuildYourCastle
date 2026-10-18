local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.SharedPackages.t)
local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local DataConfig = {}

export type CurrencyData = {
    gold: number;
}

export type CastleStructureData = {
    --[[
        [structureID -> string]
    ]]
    [string]: 
    --[[
        {isPurchaseable -> boolean, isUnlocked -> boolean}
    ]]
        {boolean};
}
export type CastleData = {
    popularity: number;
	tutorialFinished: boolean;
	floorUnlocked: {[string]: boolean};
    --[[
        [structureID -> string]: {isPurchaseable -> boolean, isUnlocked -> boolean}
    ]]
    structureData: CastleStructureData;
}

export type PlayerData = {
    currency: CurrencyData;
    castle: CastleData;
}

DataConfig.STARTING_PLAYER_GOLD = 16_000
DataConfig.FLOOR_NAMES = CastleSharedService.FLOOR_NAMES
DataConfig.STRUCTURE_NAMES = CastleSharedService.STRUCTURE_NAMES

DataConfig.DATA_TEMPLATE = {
	currency = {
		gold = DataConfig.STARTING_PLAYER_GOLD;
	};
	castle = {
		popularity = 0;
		tutorialFinished = true; --TODO: should be false, but true for testing
		floorUnlocked = {
			[DataConfig.FLOOR_NAMES.Floor1] = false;
			[DataConfig.FLOOR_NAMES.Floor2] = false;
			[DataConfig.FLOOR_NAMES.Floor3] = false;
			[DataConfig.FLOOR_NAMES.Floor4] = false;
		};
		structureData = {
			-- 1ST FLOOR
			[DataConfig.STRUCTURE_NAMES.Pathway1] = { true, false };
			[DataConfig.STRUCTURE_NAMES.Bushes1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Bushes2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Staircase1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Lamps1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Staircase2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Fountain1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Lamps2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Bush1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.CastleTower1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Bush2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.CastleTower2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Floor1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Entrance1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Windows1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Windows2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Lamps3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Lamps4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Carpet1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Doorways1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Windows3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls5] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns5] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Doorways2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls6] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns6] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Windows4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Wall1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Wall2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Staircase3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Carpet2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Display1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Wall3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Wall4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Ceiling1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Plants1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Candelabras1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Chandeliers1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Knights1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Carpet3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Decorations1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Piano1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Decorations2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner3AndPainting1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Knights2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Candelabras2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Chandeliers2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Decorations3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.ChessTable1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Decorations4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Painting2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.AngelStatue1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner4] = { false, false };

			-- 2ND FLOOR
			[DataConfig.STRUCTURE_NAMES.Walls7] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns7] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Doorway1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Fences1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.FlowerPots1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Chandeliers3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Carpet4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Wall5] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls8] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns8] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Windows5] = { false, false };
			[DataConfig.STRUCTURE_NAMES.SwordAndShield1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Knight1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Decorations5] = { false, false };
			[DataConfig.STRUCTURE_NAMES.KnightStatue1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Decorations6] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Candelabras3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner5] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner6] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner7] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls9] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns9] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Doorway2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Fences2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.FlowerPots2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Chandeliers4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Carpet5] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Wall6] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Walls10] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Columns10] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Windows6] = { false, false };
			[DataConfig.STRUCTURE_NAMES.SwordAndShield2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Knight2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Candelabras4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner8] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner9] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Banner10] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Decorations7] = { false, false };
			[DataConfig.STRUCTURE_NAMES.KnightStatue2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Decorations8] = { false, false };
			[DataConfig.STRUCTURE_NAMES.CastleTower3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Doorway3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Floor2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Fence1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Stairs1] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Stairs2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Wall7] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Stairs3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Floor3] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Stairs4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Fence2] = { false, false };
			[DataConfig.STRUCTURE_NAMES.Doorway4] = { false, false };
			[DataConfig.STRUCTURE_NAMES.CastleTower4] = { false, false };
		};
	};
}
DataConfig.DATA_SCHEMA = t.strictInterface({
	currency = t.strictInterface({
		gold = t.number;
	});
	castle = t.strictInterface({
		popularity = t.number;
		tutorialFinished = t.boolean;
		floorUnlocked = t.map(
			t.string,
			t.boolean
		),
		structureData = t.map(
			t.string,
			t.array(t.boolean)
		);
	})
})

return DataConfig
