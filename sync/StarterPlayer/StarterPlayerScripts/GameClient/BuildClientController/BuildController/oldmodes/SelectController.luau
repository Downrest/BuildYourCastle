local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local SelectController = {}

local function mount()
    
end

local function dismount()
    
end

function SelectController.Init()
	Vide.effect(function()
        if BuildGuiService.CurrentMode() == BuildGuiService.BUTTON_SELECTIONS.Select then
            mount()
        else
            dismount()
        end
	end)
end

return SelectController
