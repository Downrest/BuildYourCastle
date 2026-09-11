local StarterPlayer = game:GetService("StarterPlayer")
local BuildClientController = {}

local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local InterfaceModeController = require(script.InterfaceModeController)
local BuildModeController = require(script.BuildModeController)

function BuildClientController.Init()
    InterfaceModeController.Init()
    BuildModeController.Init()

    InterfaceModeController.PressedBuildButton:Connect(function()
        InterfaceModeController.Dismount()
        InterfaceClientService.ToggleInterface(false)
        
        BuildModeController.Mount()
    end)
end

return BuildClientController