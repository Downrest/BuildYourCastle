local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local HintGuiService = {}

export type HintGui = typeof(HintGuiService.HINT_GUI)
export type HintProps = {
    CurrentHint: Vide.source<string>;
}

HintGuiService.HINTS = {
    CannotBuild = "CannotBuild";
    FirstFloorReached = "FirstFloorReached";
}

HintGuiService.HINT_GUI = AssetSharedService.CLIENT_GUI_ASSETS.Hint

HintGuiService.CurrentHint = Vide.source("")

return HintGuiService
