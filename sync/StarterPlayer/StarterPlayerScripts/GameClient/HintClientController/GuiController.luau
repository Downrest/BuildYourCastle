local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local GuiController = {}

local interfaceGui = LocalPlayerUtil.playerGui.Interface
local hintContainer = interfaceGui.HintContainer
local hintText = hintContainer.HintText
local hintTextStroke = hintText.UIStroke

local HINT_CONTAINER_DEFAULTS = {
    position = hintContainer.Position;
}
local CANNOT_BUILD_DEFAULTS = {
    text = "You can only build on your Castle!";

    textColor = Color3.fromRGB(255, 81, 88);
    strokeColor = Color3.fromRGB(67, 18, 17);
}
local FIRST_FLOOR_REACHED_DEFAULTS = {
    text = "You have completed the first floor! Your journey begins now.";

    textColor = Color3.fromRGB(255, 213, 0);
    strokeColor = Color3.fromRGB(86, 11, 8);
}

local FADE_IN_TWEEN = TweenService:Create(
    hintContainer,
    TweenInfo.new(
        .5,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    ),
    {
        Position = HINT_CONTAINER_DEFAULTS.position;
    }
)
local FADE_OUT_TWEEN = TweenService:Create(
    hintContainer,
    TweenInfo.new(
        2,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.In
    ),
    {
        Position = HINT_CONTAINER_DEFAULTS.position;
        GroupTransparency = 1;
    }
)
local PRE_FADE_OUT_DURATION = 1

local currentHintThread: thread?

local function showHint(defaultList)
    GuiController.ResetHint()   
    do
        hintContainer.Position = HINT_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, -.01)
        hintContainer.GroupTransparency = 0
    end

    hintText.Text = defaultList.text
    hintText.TextColor3 = defaultList.textColor
    hintTextStroke.Color = defaultList.strokeColor
    
    FADE_IN_TWEEN:Play()
    currentHintThread = task.delay(PRE_FADE_OUT_DURATION, function()
        FADE_OUT_TWEEN:Play()
    end)
end

function GuiController.Init()
    GuiController.ResetHint()
    GuiController.Mount()
end

function GuiController.ResetHint()
    if currentHintThread then
        task.cancel(currentHintThread)
        currentHintThread = nil
    end

    hintContainer.GroupTransparency = 1
end

function GuiController.HintCannotBuild()
    showHint(CANNOT_BUILD_DEFAULTS)
end

function GuiController.HintFirstFloorReached()
    showHint(FIRST_FLOOR_REACHED_DEFAULTS)
end

function GuiController.Mount()
    hintContainer.Visible = true
end

function GuiController.Dismount()
    hintContainer.Visible = false
end

return GuiController
