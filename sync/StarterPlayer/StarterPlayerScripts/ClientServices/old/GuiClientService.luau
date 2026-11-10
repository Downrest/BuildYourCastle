local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GuiClientService = {}

local guiAssets = ReplicatedStorage.ClientAssets.Gui

GuiClientService.BuildMode = guiAssets.BuildMode
GuiClientService.Index = guiAssets.Index
GuiClientService.Interface = guiAssets.Interface
GuiClientService.TutorialDialogue = guiAssets.TutorialDialogue

return GuiClientService
