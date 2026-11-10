local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)

local GuiController = {}

local interfaceGui = GuiClientService.Interface
local topContainer = interfaceGui.TopContainer
local topButtonFrame = topContainer.TopButtonFrame
local castleButton = topButtonFrame.CastleButton

local CASTLE_BUTTON_DEFAULT = {
    size = castleButton.Size;
}

local castleButtonFocusTween = TweenService:Create(
    castleButton,
    GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = CASTLE_BUTTON_DEFAULT.size + UDim2.fromScale(.25, .25)
    }
)
local castleButtonDefocusTween = TweenService:Create(
    castleButton,
    GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Size = CASTLE_BUTTON_DEFAULT.size
    }
)

local guiBin = Janitor.new()

function GuiController.Mount()
	guiBin:Add(castleButton.MouseEnter:Connect(function()
        castleButtonFocusTween:Play()
	end))
    guiBin:Add(castleButton.MouseLeave:Connect(function()
        castleButtonDefocusTween:Play()
    end))
end

function GuiController.Dismount()
    do
        castleButtonDefocusTween:Play()
    end
    
	guiBin:Cleanup()
end

return GuiController
