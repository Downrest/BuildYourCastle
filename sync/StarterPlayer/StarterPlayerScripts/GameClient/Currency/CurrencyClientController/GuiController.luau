local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local QNum = require(ReplicatedStorage.SharedPackages.QNum)
local CurrencySharedService = require(ReplicatedStorage.SharedServices.CurrencySharedService)
local PlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.PlayerUtil)

local GuiController = {}

local interfaceGui = PlayerUtil.playerGui.Interface
local bottomContainer = interfaceGui.BottomContainer
local statFrame = bottomContainer.StatFrame
local currencyFrame = statFrame.Currency
local goldText = currencyFrame.GoldAmount
local goldIcon = currencyFrame.GoldIcon

local DEFAULT_GOLD_ICON = {
    size = goldIcon.Size;
    position = goldIcon.Position;
    rotation = goldIcon.Rotation;
}
local DEFAULT_GOLD_TEXT = {
    size = goldText.Size;
    position = goldText.Position;
    rotation = goldText.Rotation;
}
local DEFAULT_GOLD_TEXT_GRADIENT = {
    rotation = goldText.UIGradient.Rotation;
}

local incrementTextTween = TweenService:Create(
    goldText,
    TweenInfo.new(
        .3,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In,
        0,
        true
    ),
    {
        Size = DEFAULT_GOLD_TEXT.size + UDim2.fromScale(.03, .03);
        Position = DEFAULT_GOLD_TEXT.position + UDim2.fromScale(.015, 0);
    }
)
local incrementTextGradientTween = TweenService:Create(
    goldText.UIGradient,
    TweenInfo.new(
        .3,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In,
        0,
        true
    ),
    {
        Rotation = 180;
    }
)
local incrementIconTween = TweenService:Create(
    goldIcon,
    TweenInfo.new(
        .3,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In,
        0,
        true
    ),
    {
        Rotation = 3.5;
        Size = DEFAULT_GOLD_ICON.size + UDim2.fromScale(.05, .05);
        Position = DEFAULT_GOLD_ICON.position + UDim2.fromScale(.005, 0)
    }
)

local decrementTextTween = TweenService:Create(
    goldText,
    TweenInfo.new(
        .25,
        Enum.EasingStyle.Circular,
        Enum.EasingDirection.In,
        0,
        true
    ),
    {
        Rotation = -3;
        Size = DEFAULT_GOLD_TEXT.size - UDim2.fromScale(.025, .025);
        Position = DEFAULT_GOLD_TEXT.position - UDim2.fromScale(.035, 0);
    }
)
local decrementTextGradientTween = TweenService:Create(
    goldText.UIGradient,
    TweenInfo.new(
        .25,
        Enum.EasingStyle.Circular,
        Enum.EasingDirection.In,
        0,
        true
    ),
    {
        Rotation = -180;
    }
)
local decrementIconTween = TweenService:Create(
    goldIcon,
    TweenInfo.new(
        .25,
        Enum.EasingStyle.Circular,
        Enum.EasingDirection.In,
        0,
        true
    ),
    {
        Rotation = 5;
        Size = DEFAULT_GOLD_ICON.size - UDim2.fromScale(.05, .05);
        Position = DEFAULT_GOLD_ICON.position - UDim2.fromScale(.015, -.05)
    }
)

local tweenGoldValue = Instance.new("NumberValue")

local function clearPreviousTweens()
    do
        goldText.Position = DEFAULT_GOLD_TEXT.position
        goldText.Size = DEFAULT_GOLD_TEXT.size
        goldText.Rotation = DEFAULT_GOLD_TEXT.rotation
    end
    do
        goldText.UIGradient.Rotation = DEFAULT_GOLD_TEXT_GRADIENT.rotation
    end
    do
        goldIcon.Position = DEFAULT_GOLD_ICON.position
        goldIcon.Rotation = DEFAULT_GOLD_ICON.rotation
        goldIcon.Size = DEFAULT_GOLD_ICON.size
    end

    incrementTextTween:Cancel()
    incrementTextGradientTween:Cancel()
    incrementIconTween:Cancel()
    decrementTextTween:Cancel()
    decrementTextGradientTween:Cancel()
    decrementIconTween:Cancel()
end

local function incrementTween(newGold: number)
    clearPreviousTweens()
    
    task.wait()
    incrementTextTween:Play()
    incrementTextGradientTween:Play()
    incrementIconTween:Play()

    TweenService:Create(
        tweenGoldValue,
        TweenInfo.new(
            .3,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.In
        ),
        {
            Value = newGold
        }
    ):Play()
end

local function decrementTween(newGold: number)
    clearPreviousTweens()
    task.wait()

    decrementTextTween:Play()
    decrementTextGradientTween:Play()
    decrementIconTween:Play()

    TweenService:Create(
        tweenGoldValue,
        TweenInfo.new(
            .25,
            Enum.EasingStyle.Circular,
            Enum.EasingDirection.In
        ),
        {
            Value = newGold
        }
    ):Play()
end

local function setGold(newGold: number, oldGold: number?)
    if oldGold then
        -- tween increment
        if newGold > oldGold then
            incrementTween(newGold)

        -- tween decrement
        else
            decrementTween(newGold)
        end
    else
        tweenGoldValue.Value = newGold
    end
end

function GuiController.Mount()
    currencyFrame.Visible = true

    tweenGoldValue.Changed:Connect(function(newGold)
        goldText.Text = QNum.format(QNum.fromNumber(newGold))
    end)

    CurrencySharedService.GoldChanged.client.OnClientEvent:Connect(function(
        newGold: number, 
        oldGold: number?
    )
        setGold(newGold, oldGold)
    end)
end

function GuiController.Dismount()
    currencyFrame.Visible = false
end

return GuiController
