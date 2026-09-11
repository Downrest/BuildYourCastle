local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local CleanupUtil = require(ReplicatedStorage.SharedUtils.CleanupUtil)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local InterfaceModeController = {}

InterfaceModeController.PressedBuildButton = Signal.new()

local interfaceGui = LocalPlayerUtil.playerGui.Interface
local topContainer = interfaceGui.TopContainer
local topButtonFrame = topContainer.TopButtonFrame
local buildButton = topButtonFrame.BuildButton

local BUILD_BUTTON_DEFAULT = {
    size = buildButton.Size;
}

local buildButtonFocusTween = TweenService:Create(
    buildButton,
    GuiConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = BUILD_BUTTON_DEFAULT.size + UDim2.fromScale(.25, .25)
    }
)
local buildButtonDefocusTween = TweenService:Create(
    buildButton,
    GuiConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Size = BUILD_BUTTON_DEFAULT.size
    }
)

local interfaceModeBin = {}

function InterfaceModeController.Init()
    InterfaceModeController.Mount()
end

function InterfaceModeController.Mount()
	CleanupUtil.InsertBin(interfaceModeBin, buildButton.MouseEnter:Connect(function()
        buildButtonFocusTween:Play()
	end))
    CleanupUtil.InsertBin(interfaceModeBin, buildButton.MouseLeave:Connect(function()
        buildButtonDefocusTween:Play()
    end))

    CleanupUtil.InsertBin(interfaceModeBin, buildButton.Activated:Connect(function()
        InterfaceModeController.PressedBuildButton:Fire()
    end))
end

function InterfaceModeController.Dismount()
	CleanupUtil.Clean(interfaceModeBin)
end

return InterfaceModeController
