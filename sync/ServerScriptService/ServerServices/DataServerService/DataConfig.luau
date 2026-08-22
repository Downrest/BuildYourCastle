local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.SharedPackages.t)
local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local DataConfig = {}

DataConfig.STARTING_PLAYER_GOLD = 16_000

DataConfig.DATA_TEMPLATE = {
	currency = {
		gold = DataConfig.STARTING_PLAYER_GOLD;
	};
	castle = {
		popularity = 0;
		unlockedFirstFloor = false;
		structureData = {
			-- 1ST FLOOR
			[CastleSharedService.STRUCTURE_NAMES.Pathway1] = { true, false };
			[CastleSharedService.STRUCTURE_NAMES.Bushes1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Bushes2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Staircase1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Lamps1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Staircase2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Fountain1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Lamps2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Walls1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Banner1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Bush1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.CastleTower1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Banner2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Bush2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.CastleTower2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Floor1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Entrance1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Walls2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Windows1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Windows2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Columns1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Lamps3] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Columns2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Lamps4] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Carpet1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Walls3] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Columns3] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Doorways1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Walls4] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Columns4] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Windows3] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Walls5] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Columns5] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Doorways2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Walls6] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Columns6] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Windows4] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Wall1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Wall2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Staircase3] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Carpet2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Display1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Wall3] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Wall4] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Ceiling1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Plants1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Candelabras1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Chandeliers1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Knights1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Carpet3] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Decorations1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Piano1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Decorations2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Banner3AndPainting1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Knights2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Candelabras2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Chandeliers2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Decorations3] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.ChessTable1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Decorations4] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Painting2] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.AngelStatue1] = { false, false };
			[CastleSharedService.STRUCTURE_NAMES.Banner4] = { false, false };
		};
	};
}
DataConfig.DATA_SCHEMA = t.strictInterface({
	currency = t.strictInterface({
		gold = t.number;
	});
	castle = t.strictInterface({
		popularity = t.number;
		unlockedFirstFloor = t.boolean;
		structureData = t.map(
			t.string,
			t.array(t.boolean)
		);
	})
})

return DataConfig
