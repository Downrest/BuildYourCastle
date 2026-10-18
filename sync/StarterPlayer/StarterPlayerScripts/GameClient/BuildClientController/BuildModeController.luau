local StarterPlayer = game:GetService("StarterPlayer")

local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local StructureController = require(script.GuiControllers.StructureController)
local TopButtonController = require(script.GuiControllers.TopButtonController)
local BuildController = require(script.BuildController)

local BuildModeController = {}

local buildModeGui = LocalPlayerUtil.playerGui.BuildMode

function BuildModeController.Init()
    buildModeGui.Enabled = true

    do
        StructureController.Init()
        TopButtonController.Init()
    end
    
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