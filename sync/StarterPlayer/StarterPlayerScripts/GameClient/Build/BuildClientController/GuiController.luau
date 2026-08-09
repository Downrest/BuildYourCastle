local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)
local CleanupUtil = require(ReplicatedStorage.SharedUtils.CleanupUtil)
local PlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.PlayerUtil)

local GuiController = {}

local interfaceGui = PlayerUtil.playerGui.Interface
local topContainer = interfaceGui.TopContainer
local topButtonFrame = topContainer.TopButtonFrame
local buildButton = topButtonFrame.BuildButton

local BUILD_BUTTON_DEFAULT = {
    size = buildButton.Size;
}

local buildButtonFocusTween = TweenService:Create(
    buildButton,
    GuiClientService.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = BUILD_BUTTON_DEFAULT.size + UDim2.fromScale(.25, .25)
    }
)
local buildButtonDefocusTween = TweenService:Create(
    buildButton,
    GuiClientService.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Size = BUILD_BUTTON_DEFAULT.size
    }
)

local guiBin = {}

function GuiController.Mount()
	CleanupUtil.InsertBin(guiBin, buildButton.MouseEnter:Connect(function()
        buildButtonFocusTween:Play()
	end))

    CleanupUtil.InsertBin(guiBin, buildButton.MouseLeave:Connect(function()
        buildButtonDefocusTween:Play()
    end))
end

function GuiController.Dismount()
	CleanupUtil.Clean(guiBin)
end

return GuiController
