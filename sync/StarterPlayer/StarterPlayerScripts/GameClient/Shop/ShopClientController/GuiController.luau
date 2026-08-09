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
local shopButton = topButtonFrame.ShopButton

local SHOP_BUTTON_DEFAULT = {
    size = shopButton.Size;
}

local shopButtonFocusTween = TweenService:Create(
    shopButton,
    GuiClientService.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = SHOP_BUTTON_DEFAULT.size + UDim2.fromScale(.25, .25)
    }
)
local shopButtonDefocusTween = TweenService:Create(
    shopButton,
    GuiClientService.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Size = SHOP_BUTTON_DEFAULT.size
    }
)

local guiBin = {}

function GuiController.Mount()
	CleanupUtil.InsertBin(guiBin, shopButton.MouseEnter:Connect(function()
        shopButtonFocusTween:Play()
	end))
    
    CleanupUtil.InsertBin(guiBin, shopButton.MouseLeave:Connect(function()
        shopButtonDefocusTween:Play()
    end))
end

function GuiController.Dismount()
	CleanupUtil.Clean(guiBin)
end

return GuiController
