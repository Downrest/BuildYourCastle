local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local BuildClientService = {}

export type BuildData = {
	model: Model;
	modelSize: Vector3;
	adorneePart: BasePart;
}

type HandleModel = Model & {
	Origin: BasePart;
}
export type HandleData = {
	handleModel: HandleModel;
	handleScale: number;
	handleAdornmentDefaults: {
		{ 
			type: string;
			asset: SphereHandleAdornment | ConeHandleAdornment | CylinderHandleAdornment;
		}
	};
}

BuildClientService.HANDLE_DIRECTIONS = {
	Up = "Up";
	Down = "Down";
	Front = "Front";
	Back = "Back";
	Left = "Left";
	Right = "Right";
}
BuildClientService.HANDLE_DIRECTION_GROUPS = {
	UpDown = { BuildClientService.HANDLE_DIRECTIONS.Up, BuildClientService.HANDLE_DIRECTIONS.Down };
	LeftRight = { BuildClientService.HANDLE_DIRECTIONS.Left, BuildClientService.HANDLE_DIRECTIONS.Right };
	FrontBack = { BuildClientService.HANDLE_DIRECTIONS.Front, BuildClientService.HANDLE_DIRECTIONS.Back };
}
BuildClientService.HANDLE_UNRENDER_CFRAME = CFrame.new(0, 1000, 0)
BuildClientService.HANDLE_OFFSET = 2

BuildClientService.HANDLE_STATES = {
	Select = "Select";
	Move = "Move";
	Rotate = "Rotate";
	Delete = "Delete";
}
BuildClientService.HANDLE_ADORNMENT_TYPES = {
	SphereHandleAdornment = "SphereHandleAdornment";
	ConeHandleAdornment = "ConeHandleAdornment";
	CylinderHandleAdornment = "CylinderHandleAdornment";
}

BuildClientService.NIL_BUILD_DATA = {}:: BuildData
BuildClientService.NIL_HANDLE_DATA = {}:: HandleData

BuildClientService.CurrentBuildData = Vide.source(BuildClientService.NIL_BUILD_DATA)
BuildClientService.CurrentHandleData = Vide.source(BuildClientService.NIL_HANDLE_DATA)

BuildClientService.BuildDataCache = {}:: { [string]: BuildData }

return BuildClientService
