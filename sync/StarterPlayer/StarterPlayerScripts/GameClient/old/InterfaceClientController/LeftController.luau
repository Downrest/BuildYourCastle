local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)

local LeftController = {}

local interfaceGui = GuiClientService.Interface
local leftContainer = interfaceGui.LeftContainer

local LEFT_CONTAINER_DEFAULTS = {
    position = leftContainer.Position;
}
local LEFT_FOCUS_POSITION = LEFT_CONTAINER_DEFAULTS.position
local LEFT_DEFOCUS_POSITION = LEFT_CONTAINER_DEFAULTS.position + UDim2.fromScale(-.5, 0)

local LEFT_FOCUS_TWEEN_SLOW = TweenService:Create(
    leftContainer,
    GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_SLOW_TWEEN_INFO,
    {
        Position = LEFT_FOCUS_POSITION;
    }
)
local LEFT_DEFOCUS_TWEEN_SLOW = TweenService:Create(
    leftContainer,
    GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_SLOW_TWEEN_INFO,
    {
        Position = LEFT_DEFOCUS_POSITION;
    }
)

local LEFT_FOCUS_TWEEN_DEFAULT = TweenService:Create(
    leftContainer,
    GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = LEFT_FOCUS_POSITION;
    }
)
local LEFT_DEFOCUS_TWEEN_DEFAULT = TweenService:Create(
    leftContainer,
    GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
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
