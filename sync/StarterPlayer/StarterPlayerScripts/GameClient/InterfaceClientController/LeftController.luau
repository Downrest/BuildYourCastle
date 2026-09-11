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

local LEFT_FOCUS_TWEEN_SLOW = TweenService:Create(
    leftContainer,
    GuiConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = LEFT_FOCUS_POSITION;
    }
)
local LEFT_DEFOCUS_TWEEN_SLOW = TweenService:Create(
    leftContainer,
    GuiConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = LEFT_DEFOCUS_POSITION;
    }
)

local LEFT_FOCUS_TWEEN_DEFAULT = TweenService:Create(
    leftContainer,
    GuiConfig.MENU_FOCUS_TWEEN_INFO,
    {
        Position = LEFT_FOCUS_POSITION;
    }
)
local LEFT_DEFOCUS_TWEEN_DEFAULT = TweenService:Create(
    leftContainer,
    GuiConfig.MENU_DEFOCUS_TWEEN_INFO,
    {
        Position = LEFT_DEFOCUS_POSITION;
    }
)

function LeftController.Init()
    LeftController.Toggle(false)
end

function LeftController.Toggle(isFocused: boolean, isSlow: boolean?)
    if isFocused then
        if isSlow then
            LEFT_FOCUS_TWEEN_SLOW:Play()
        else
            LEFT_FOCUS_TWEEN_DEFAULT:Play()
        end
    else
        if isSlow then
            LEFT_DEFOCUS_TWEEN_SLOW:Play()
        else
            LEFT_DEFOCUS_TWEEN_DEFAULT:Play()
        end
    end
end

return LeftController
