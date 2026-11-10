local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

HintGuiService.HINT_GUI = ReplicatedStorage.ClientAssets.Gui.Hint

HintGuiService.CurrentHint = Vide.source("")

return HintGuiService
