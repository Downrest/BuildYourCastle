local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local BuildClientService = {}

BuildClientService.CATEGORY_NAMES = {
    All = "All";
    Decor = "Decor";
    Nature = "Nature";
    Special = "Special";
}
BuildClientService.CurrentCategory = Vide.source("")

BuildClientService.IsBuildMode = Vide.source(false)

return BuildClientService
