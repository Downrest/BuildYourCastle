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
local shopButton = topButtonFrame.ShopButton

local SHOP_BUTTON_DEFAULT = {
    size = shopButton.Size;
}

local shopButtonFocusTween = TweenService:Create(
    shopButton,
    GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
    {
        Size = SHOP_BUTTON_DEFAULT.size + UDim2.fromScale(.25, .25)
    }
)
local shopButtonDefocusTween = TweenService:Create(
    shopButton,
    GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
    {
        Size = SHOP_BUTTON_DEFAULT.size
    }
)

local guiBin = Janitor.new()

function GuiController.Init()
    GuiController.Dismount()
end

function GuiController.Mount()
	guiBin:Add(shopButton.MouseEnter:Connect(function()
        shopButtonFocusTween:Play()
	end))
    guiBin:Add(shopButton.MouseLeave:Connect(function()
        shopButtonDefocusTween:Play()
    end))
end

function GuiController.Dismount()
    do
        shopButtonDefocusTween:Play()
    end
    
	guiBin:Cleanup()
end

return GuiController
