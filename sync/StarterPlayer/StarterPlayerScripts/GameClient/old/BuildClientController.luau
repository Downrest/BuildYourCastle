local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local BuildClientController = {}

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local InterfaceModeController = require(script.InterfaceModeController)
local BuildModeController = require(script.BuildModeController)

local function toggleBuild(isBuildMode: boolean)
    if isBuildMode then
        InterfaceModeController.Dismount()
        BuildModeController.Mount()
    else
        InterfaceModeController.Mount()
        BuildModeController.Dismount()
    end

    InterfaceClientService.IsInterfaceEnabled(not isBuildMode)
end

function BuildClientController.Init()
    InterfaceModeController.Init()
    BuildModeController.Init()

    Vide.effect(function()
        toggleBuild(
            BuildClientService.IsBuildMode()
        )
    end)
end

return BuildClientController