local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local TopButtonController = {}

local buildModeGui = LocalPlayerUtil.playerGui.BuildMode

local topButtonContainer = buildModeGui.TopButtonContainer
local deleteButton = topButtonContainer.Delete
local moveButton = topButtonContainer.Move
local rotateButton = topButtonContainer.Rotate
local selectButton = topButtonContainer.Select

local TOP_BUTTON_CONTAINER_DEFAULTS = {
    position = topButtonContainer.Position;
}

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

local topButtonBin = Janitor.new()

function TopButtonController.Init()
    TopButtonController.Dismount()
end

function TopButtonController.Mount()
    TOP_BUTTON_CONTAINER_FOCUS_TWEEN:Play()

    do
        topButtonBin:Add(deleteButton.Activated:Connect(function()
            BuildClientService.CurrentButtonSelection(BuildClientService.BUTTON_SELECTIONS.Delete)
        end))
        topButtonBin:Add(moveButton.Activated:Connect(function()
            BuildClientService.CurrentButtonSelection(BuildClientService.BUTTON_SELECTIONS.Move)
        end))
        topButtonBin:Add(rotateButton.Activated:Connect(function()
            BuildClientService.CurrentButtonSelection(BuildClientService.BUTTON_SELECTIONS.Rotate)
        end))
        topButtonBin:Add(selectButton.Activated:Connect(function()
            BuildClientService.CurrentButtonSelection(BuildClientService.BUTTON_SELECTIONS.Select)
        end))
    end
end

function TopButtonController.Dismount()
    TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN:Play()
    topButtonBin:Cleanup()
end

return TopButtonController