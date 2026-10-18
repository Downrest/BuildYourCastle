local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Replicator = require(ReplicatedStorage.SharedPackages.Replicator)

local DataSharedService = {}

export type PlayerState = Replicator.Replica<{
	currency: {
		gold: number;
	};
	castle: {
		tutorialFinished: boolean;
		floorUnlocked: {
			floor1: boolean;
			floor2: boolean;
			floor3: boolean;
			floor4: boolean;
		};
	}
}>

DataSharedService.PlayerStream = Replicator.stream(
	"PlayerStream", 
	{
		currency = {
			gold = 0;
		};
		castle = {
			tutorialFinished = false;
			floorUnlocked = {
				floor1 = false;
				floor2 = false;
				floor3 = false;
				floor4 = false;
			};
		};
	}
)

return DataSharedService





