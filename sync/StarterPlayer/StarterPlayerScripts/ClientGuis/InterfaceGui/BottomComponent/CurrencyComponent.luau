local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local QNum = require(ReplicatedStorage.SharedPackages.QNum)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)

local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)

return function(
    gui: InterfaceGuiService.InterfaceGui,
    props: InterfaceGuiService.InterfaceProps
)
    VideUtils.scope(function(bin)
        local bottomContainer = gui.BottomContainer
        local stateFrame = bottomContainer.StatFrame
        local currency = stateFrame.Currency
        local goldText = currency.GoldAmount
        local goldIcon = currency.GoldIcon
        local goldGradient = goldText.UIGradient

        local GOLD_ICON_DEFAULTS = {
            size = goldIcon.Size;
            position = goldIcon.Position;
            rotation = goldIcon.Rotation;
        }
        local GOLD_TEXT_DEFAULTS = {
            size = goldText.Size;
            position = goldText.Position;
            rotation = goldText.Rotation;
        }
        local GOLD_GRADIENT_DEFAULTS = {
            rotation = goldGradient.Rotation;
        }

        local INCREMENT_TWEEN_INFO = TweenInfo.new(.3, Enum.EasingStyle.Back, Enum.EasingDirection.In, 0, true)
        local DECREMENT_TWEEN_INFO = TweenInfo.new(.25, Enum.EasingStyle.Circular, Enum.EasingDirection.In, 0, true)
        local INCREMENT_COUNT_TWEEN_INFO = TweenInfo.new(.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        local DECREMENT_COUNT_TWEEN_INFO = TweenInfo.new(.25, Enum.EasingStyle.Circular, Enum.EasingDirection.In)
        local INCREMENT_TEXT_TWEEN = bin:Add(TweenService:Create(goldText, INCREMENT_TWEEN_INFO, {
            Size = GOLD_TEXT_DEFAULTS.size + UDim2.fromScale(.03, .03);
            Position = GOLD_TEXT_DEFAULTS.position + UDim2.fromScale(.015, 0);
        }))
        local INCREMENT_GRADIENT_TWEEN = bin:Add(TweenService:Create(goldGradient, INCREMENT_TWEEN_INFO, {
            Rotation = 180;
        }))
        local INCREMENT_ICON_TWEEN = bin:Add(TweenService:Create(goldIcon, INCREMENT_TWEEN_INFO, {
            Rotation = 3.5;
            Size = GOLD_ICON_DEFAULTS.size + UDim2.fromScale(.05, .05);
            Position = GOLD_ICON_DEFAULTS.position + UDim2.fromScale(.005, 0);
        }))
        local DECREMENT_TEXT_TWEEN = bin:Add(TweenService:Create(goldText, DECREMENT_TWEEN_INFO, {
            Rotation = -3;
            Size = GOLD_TEXT_DEFAULTS.size - UDim2.fromScale(.025, .025);
            Position = GOLD_TEXT_DEFAULTS.position - UDim2.fromScale(.035, 0);
        }))
        local DECREMENT_GRADIENT_TWEEN = bin:Add(TweenService:Create(goldGradient, DECREMENT_TWEEN_INFO, {
            Rotation = -180;
        }))
        local DECREMENT_ICON_TWEEN = bin:Add(TweenService:Create(goldIcon, DECREMENT_TWEEN_INFO, {
            Rotation = 5;
            Size = GOLD_ICON_DEFAULTS.size - UDim2.fromScale(.05, .05);
            Position = GOLD_ICON_DEFAULTS.position - UDim2.fromScale(.015, -.05);
        }))

        local currentGoldValue = bin:Add(Instance.new("NumberValue"))

        local function resetAnimations(oldGold: number)
            currentGoldValue.Value = oldGold

            do
                goldText.Position = GOLD_TEXT_DEFAULTS.position
                goldText.Size = GOLD_TEXT_DEFAULTS.size
                goldText.Rotation = GOLD_TEXT_DEFAULTS.rotation
                goldText.UIGradient.Rotation = GOLD_GRADIENT_DEFAULTS.rotation
                goldIcon.Position = GOLD_ICON_DEFAULTS.position
                goldIcon.Rotation = GOLD_ICON_DEFAULTS.rotation
                goldIcon.Size = GOLD_ICON_DEFAULTS.size
            end
        
            do
                INCREMENT_TEXT_TWEEN:Cancel()
                INCREMENT_GRADIENT_TWEEN:Cancel()
                INCREMENT_ICON_TWEEN:Cancel()
                DECREMENT_TEXT_TWEEN:Cancel()
                DECREMENT_GRADIENT_TWEEN:Cancel()
                DECREMENT_ICON_TWEEN:Cancel()
            end
        end

        bin:Add(currentGoldValue.Changed:Connect(function(newGold)
            goldText.Text = QNum.format(QNum.fromNumber(newGold))
        end))

        Vide.effect(function()
            local newGold = props.CurrentGold()
            local oldGold = Vide.untrack(props.PreviousGold)

            if oldGold == 0 or oldGold == newGold then
                currentGoldValue.Value = newGold
                return
            end

            local isIncrementing = (newGold > oldGold)

            resetAnimations(oldGold)

            if isIncrementing then
                INCREMENT_TEXT_TWEEN:Play()
                INCREMENT_GRADIENT_TWEEN:Play()
                INCREMENT_ICON_TWEEN:Play()
            else
                DECREMENT_TEXT_TWEEN:Play()
                DECREMENT_GRADIENT_TWEEN:Play()
                DECREMENT_ICON_TWEEN:Play()
            end
            bin:Add(TweenService:Create(
                currentGoldValue, 
                isIncrementing and INCREMENT_COUNT_TWEEN_INFO or DECREMENT_COUNT_TWEEN_INFO, 
                {
                    Value = newGold;
                }
            )):Play()
        end)
    end)
end
