local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local CastleClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.CastleClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local GuiController = require(script.GuiController)

local HintClientController = {}

function HintClientController.Init()
    GuiController.Init()

    Vide.effect(function()
        if CastleClientService.IsFirstFloorUnlocked() then
            GuiController.HintFirstFloorReached()
        end
    end)
end

return HintClientController