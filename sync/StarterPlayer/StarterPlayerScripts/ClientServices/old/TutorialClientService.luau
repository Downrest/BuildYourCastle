local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local TutorialClientService = {}

TutorialClientService.TutorialFinished = Vide.source(false)

function TutorialClientService.Init()
    DataClientService.PlayerState.castle.tutorialFinished.Observed(function(new)
        TutorialClientService.TutorialFinished(new)
    end)
end

return TutorialClientService
