local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local TutorialClientService = {}

TutorialClientService.TutorialFinished = Vide.source(
    DataClientService.PlayerState.castle.tutorialFinished:Get()
)

function TutorialClientService.Init()
    Vide.effect(function()
        TutorialClientService.TutorialFinished()
    end)
end

return TutorialClientService
