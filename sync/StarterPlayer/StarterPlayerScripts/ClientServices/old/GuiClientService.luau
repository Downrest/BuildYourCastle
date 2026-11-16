local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)
local GuiClientService = {}

local guiAssets = AssetSharedService.CLIENT_GUI_ASSETS

GuiClientService.BuildMode = guiAssets.BuildMode
GuiClientService.Index = guiAssets.Index
GuiClientService.Interface = guiAssets.Interface
GuiClientService.TutorialDialogue = guiAssets.TutorialDialogue

return GuiClientService
