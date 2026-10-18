local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local InterfaceModeController = {}

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

local interfaceModeBin = Janitor.new()

function InterfaceModeController.Init()
    InterfaceModeController.Mount()
end

function InterfaceModeController.Mount()
    -- exit tween
    interfaceModeBin:Add(function()
        buildButtonDefocusTween:Play()
    end)

	interfaceModeBin:Add(buildButton.MouseEnter:Connect(function()
        buildButtonFocusTween:Play()
	end))
    interfaceModeBin:Add(buildButton.MouseLeave:Connect(function()
        buildButtonDefocusTween:Play()
    end))

    interfaceModeBin:Add(buildButton.Activated:Connect(function()
        BuildClientService.IsBuildMode(true)
    end))
end

function InterfaceModeController.Dismount()
	interfaceModeBin:Cleanup()
end

return InterfaceModeController
