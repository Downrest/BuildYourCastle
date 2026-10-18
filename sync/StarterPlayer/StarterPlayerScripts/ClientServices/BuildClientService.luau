local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local BuildClientService = {}

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

BuildClientService.CurrentCategory = Vide.source("")
BuildClientService.CurrentButtonSelection = Vide.source("")
BuildClientService.IsBuildMode = Vide.source(false)

return BuildClientService