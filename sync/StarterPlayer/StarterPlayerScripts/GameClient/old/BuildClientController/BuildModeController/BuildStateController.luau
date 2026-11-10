local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildStateConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.BuildStateConfig)

local BuildStateController = {}

local currentState: BuildStateConfig.BuildState;

function BuildStateController.Init()
    Vide.effect(function()
        currentState.Enter()
    end)
end

return BuildStateController
