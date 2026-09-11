local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local CleanupUtil = require(ReplicatedStorage.SharedUtils.CleanupUtil)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local GuiController = {}

local interfaceGui = LocalPlayerUtil.playerGui.Interface
local topContainer = interfaceGui.TopContainer
local topButtonFrame = topContainer.TopButtonFrame
local castleButton = topButtonFrame.CastleButton

local CASTLE_BUTTON_DEFAULT = {
    size = castleButton.Size;
}

local castleButtonFocusTween = TweenService:Create(
    castleButton,
    GuiConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = CASTLE_BUTTON_DEFAULT.size + UDim2.fromScale(.25, .25)
    }
)
local castleButtonDefocusTween = TweenService:Create(
    castleButton,
    GuiConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Size = CASTLE_BUTTON_DEFAULT.size
    }
)

local guiBin = {}

function GuiController.Mount()
	CleanupUtil.InsertBin(guiBin, castleButton.MouseEnter:Connect(function()
        castleButtonFocusTween:Play()
	end))
    
    CleanupUtil.InsertBin(guiBin, castleButton.MouseLeave:Connect(function()
        castleButtonDefocusTween:Play()
    end))
end

function GuiController.Dismount()
	CleanupUtil.Clean(guiBin)
end

return GuiController
