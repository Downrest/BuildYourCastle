local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local HintGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.HintGuiService)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)

type HintData = {
    text: string;
    textColor: Color3;
    strokeColor: Color3;
}

local HINT_DATA: {[string]: HintData} = {
    [HintGuiService.HINTS.CannotBuild] = {
        text = "You can only build on your Castle!";
        textColor = Color3.fromRGB(255, 81, 88);
        strokeColor = Color3.fromRGB(67, 18, 17);
    };
    [HintGuiService.HINTS.FirstFloorReached] = {
        text = "You have completed the first floor! Your journey begins now.";
        textColor = Color3.fromRGB(255, 213, 0);
        strokeColor = Color3.fromRGB(86, 11, 8);
    };
}
local FADE_IN_TWEEN_INFO = TweenInfo.new(
    .5,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)
local FADE_OUT_TWEEN_INFO = TweenInfo.new(
    2,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.In
)
local PRE_FADE_OUT_DURATION = 1

return function(
    gui: HintGuiService.HintGui,
    props: HintGuiService.HintProps
)
    VideUtils.scope(function(bin)
        local hintContainer = gui.TopHintContainer
        local hintText = hintContainer.HintText
        local hintTextStroke = hintText.UIStroke

        local animBin = Janitor.new(); do
            bin:Add(animBin)
        end

        local HINT_CONTAINER_DEFAULTS = {
            position = hintContainer.Position;
        }
        local PRE_IN_HINT_CONTAINER_POSITION = HINT_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, -.01)
        local FADE_IN_TWEEN = animBin:Add(TweenService:Create(
            hintContainer,
            FADE_IN_TWEEN_INFO,
            {
                Position = HINT_CONTAINER_DEFAULTS.position;
            }
        ))
        local FADE_OUT_TWEEN = animBin:Add(TweenService:Create(
            hintContainer,
            FADE_OUT_TWEEN_INFO,
            {
                GroupTransparency = 1;
            }
        ))

        -- show hint
        Vide.effect(function()
            local hintData = HINT_DATA[props.CurrentHint()]

            if hintData then
                do
                    hintContainer.Position = PRE_IN_HINT_CONTAINER_POSITION
                    hintContainer.GroupTransparency = 0

                    FADE_IN_TWEEN:Cancel()
                    FADE_OUT_TWEEN:Cancel()

                    hintText.Text = hintData.text
                    hintText.TextColor3 = hintData.textColor
                    hintTextStroke.Color = hintData.strokeColor
                end

                FADE_IN_TWEEN:Play()
                animBin:Add(task.delay(PRE_FADE_OUT_DURATION, function()
                    FADE_OUT_TWEEN:Play()
                end))
                animBin:Add(FADE_OUT_TWEEN.Completed:Once(function()
                    props.CurrentHint("")
                end))
            end
        end)
    end)
end
