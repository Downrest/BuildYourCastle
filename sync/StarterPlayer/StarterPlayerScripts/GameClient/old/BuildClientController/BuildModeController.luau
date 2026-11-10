local StarterPlayer = game:GetService("StarterPlayer")

local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)
local StructureController = require(script.GuiControllers.StructureController)
local TopButtonController = require(script.GuiControllers.TopButtonController)
local BuildController = require(script.BuildController)

local BuildModeController = {}

local buildModeGui = GuiClientService.BuildMode

function BuildModeController.Init()
    do
        StructureController.Init()
        TopButtonController.Init()
        BuildController.Init()
    end
    
    buildModeGui.Enabled = true
    BuildModeController.Dismount()
end

function BuildModeController.Mount()
    StructureController.Mount()
    TopButtonController.Mount()
    BuildController.Mount()
end

function BuildModeController.Dismount()
    StructureController.Dismount()
    TopButtonController.Dismount()
    BuildController.Dismount()
end

return BuildModeController