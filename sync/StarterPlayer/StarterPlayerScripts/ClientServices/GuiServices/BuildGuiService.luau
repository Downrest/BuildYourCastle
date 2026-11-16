local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local BuildGuiService = {}

export type BuildGui = typeof(BuildGuiService.BUILD_GUI)
export type BuildProps = {
    IsVisible: Vide.source<boolean>;
    CurrentMode: Vide.source<string>;
    CurrentCategory: Vide.source<string>;
    CurrentBuildSelection: Vide.source<string>;

    ExitPressed: Signal.Signal;
}

BuildGuiService.BUTTON_SELECTIONS = { --TODO: change this to BUILD_MODES
    Select = "Select";
    Move = "Move";
    Rotate = "Rotate";
    Delete = "Delete";
}
BuildGuiService.BUILD_GUI = AssetSharedService.CLIENT_GUI_ASSETS.Build

BuildGuiService.IsVisible = Vide.source(false)
BuildGuiService.CurrentMode = Vide.source("")
BuildGuiService.CurrentCategory = Vide.source("")
BuildGuiService.CurrentBuildSelection = Vide.source("")

BuildGuiService.ExitPressed = Signal.new()

return BuildGuiService
