local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)

local BuildClientService = {}

local moveHandleAssets = AssetSharedService.BUILD_MOVE_HANDLE_ASSETS

BuildClientService.CATEGORY_NAMES = {
    All = "All";
    Decor = "Decor";
    Nature = "Nature";
    Special = "Special";
}
BuildClientService.BUTTON_SELECTIONS = {
    Select = "Select";
    Move = "Move";
    Rotate = "Rotate";
    Delete = "Delete";
}

BuildClientService.MOVE_DIRECTIONS = {
	Up = "Up";
	Down = "Down";
	Front = "Front";
	Back = "Back";
	Left = "Left";
	Right = "Right";
}
BuildClientService.MOVE_HANDLES = {
    [BuildClientService.MOVE_DIRECTIONS.Up] = moveHandleAssets.UpHandle:Clone();
    [BuildClientService.MOVE_DIRECTIONS.Down] = moveHandleAssets.DownHandle:Clone();
    [BuildClientService.MOVE_DIRECTIONS.Front] = moveHandleAssets.FrontHandle:Clone();
    [BuildClientService.MOVE_DIRECTIONS.Back] = moveHandleAssets.BackHandle:Clone();
    [BuildClientService.MOVE_DIRECTIONS.Left] = moveHandleAssets.LeftHandle:Clone();
    [BuildClientService.MOVE_DIRECTIONS.Right] = moveHandleAssets.RightHandle:Clone();
}

BuildClientService.CurrentCategory = Vide.source("")
BuildClientService.CurrentButtonSelection = Vide.source("")

BuildClientService.CurrentBuildSelected = Vide.source("")

BuildClientService.IsBuildMode = Vide.source(false)

return BuildClientService
