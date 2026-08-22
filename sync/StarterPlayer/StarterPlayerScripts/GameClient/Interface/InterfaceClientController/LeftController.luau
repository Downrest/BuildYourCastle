local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local LeftController = {}

local interfaceGui = LocalPlayerUtil.playerGui.Interface
local leftContainer = interfaceGui.LeftContainer

local LEFT_CONTAINER_DEFAULTS = {
    position = leftContainer.Position;
}
local LEFT_FOCUS_POSITION = LEFT_CONTAINER_DEFAULTS.position
local LEFT_DEFOCUS_POSITION = LEFT_CONTAINER_DEFAULTS.position + UDim2.fromScale(-3, 0)

local leftFocusTween = TweenService:Create(
    leftContainer,
    GuiConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = LEFT_FOCUS_POSITION;
    }
)
local leftDefocusTween = TweenService:Create(
    leftContainer,
    GuiConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = LEFT_DEFOCUS_POSITION;
    }
)

function LeftController.Init()
    LeftController.Toggle(false)
end

function LeftController.Toggle(isFocused: boolean, isAnimated: boolean?)
    if isFocused then
        if isAnimated then
            leftFocusTween:Play()
        else
            leftContainer.Position = LEFT_FOCUS_POSITION
        end
    else
        if isAnimated then
            leftDefocusTween:Play()
        else
            leftContainer.Position = LEFT_DEFOCUS_POSITION
        end
    end
end

return LeftController
