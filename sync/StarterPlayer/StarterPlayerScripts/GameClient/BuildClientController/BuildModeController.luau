local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local StructureController = require(script.StructureController)

local BuildModeController = {}

BuildModeController.CurrentCategory = Vide.source("")

BuildModeController.PressedExitButton = Signal.new()

local buildModeGui = LocalPlayerUtil.playerGui.BuildMode

local structureContainer = buildModeGui.StructureContainer
local topButtonContainer = buildModeGui.TopButtonContainer

local STRUCTURE_CONTAINER_DEFAULTS = {
    position = structureContainer.Position;
}
local TOP_BUTTON_CONTAINER_DEFAULTS = {
    position = topButtonContainer.Position;
}

local STRUCTURE_CONTAINER_FOCUS_TWEEN = TweenService:Create(
    structureContainer,
    GuiConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = STRUCTURE_CONTAINER_DEFAULTS.position;
    }
)
local STRUCTURE_CONTAINER_DEFOCUS_TWEEN = TweenService:Create(
    structureContainer,
    GuiConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = STRUCTURE_CONTAINER_DEFAULTS.position + UDim2.fromScale(.5, 0);
    }
)
local TOP_BUTTON_CONTAINER_FOCUS_TWEEN = TweenService:Create(
    topButtonContainer,
    GuiConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = TOP_BUTTON_CONTAINER_DEFAULTS.position;
    }
)
local TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN = TweenService:Create(
    topButtonContainer,
    GuiConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = TOP_BUTTON_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, -.5);
    }
)

local buildModeBin = Janitor.new()
local currentVideScope

function BuildModeController.Init()
    buildModeGui.Enabled = true

    BuildModeController.Dismount()
end

function BuildModeController.Mount()
    currentVideScope = Vide.root(function()
        do
            STRUCTURE_CONTAINER_FOCUS_TWEEN:Play()
            TOP_BUTTON_CONTAINER_FOCUS_TWEEN:Play()
        end

        StructureController.Mount()        
    end)
end

function BuildModeController.Dismount()
    do
        STRUCTURE_CONTAINER_DEFOCUS_TWEEN:Play()
        TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN:Play()
    end

    StructureController.Dismount()

    if currentVideScope then
        currentVideScope()
    end
    buildModeBin:Cleanup()
end

return BuildModeController