local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local BottomController = {}

local interfaceGui = LocalPlayerUtil.playerGui.Interface
local bottomContainer = interfaceGui.BottomContainer

local BOTTOM_CONTAINER_DEFAULTS = {
    position = bottomContainer.Position;
}
local BOTTOM_FOCUS_POSITION = BOTTOM_CONTAINER_DEFAULTS.position
local BOTTOM_DEFOCUS_POSITION = BOTTOM_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, .5)

local BOTTOM_FOCUS_TWEEN_SLOW = TweenService:Create(
    bottomContainer,
    GuiConfig.INTERFACE_CONTAINER_FOCUS_SLOW_TWEEN_INFO,
    {
        Position = BOTTOM_FOCUS_POSITION;
    }
)
local BOTTOM_DEFOCUS_TWEEN_SLOW = TweenService:Create(
    bottomContainer,
    GuiConfig.INTERFACE_CONTAINER_DEFOCUS_SLOW_TWEEN_INFO,
    {
        Position = BOTTOM_DEFOCUS_POSITION;
    }
)

local BOTTOM_FOCUS_TWEEN_DEFAULT = TweenService:Create(
    bottomContainer,
    GuiConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = BOTTOM_FOCUS_POSITION;
    }
)
local BOTTOM_DEFOCUS_TWEEN_DEFAULT = TweenService:Create(
    bottomContainer,
    GuiConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = BOTTOM_DEFOCUS_POSITION;
    }
)

function BottomController.Init()
    BottomController.Toggle(false)
end

function BottomController.Toggle(isFocused: boolean, isSlow: boolean?)
    if isFocused then
        if isSlow then
            BOTTOM_FOCUS_TWEEN_SLOW:Play()
        else
            BOTTOM_FOCUS_TWEEN_DEFAULT:Play()
        end
    else
        if isSlow then
            BOTTOM_DEFOCUS_TWEEN_SLOW:Play()
        else
            BOTTOM_DEFOCUS_TWEEN_DEFAULT:Play()
        end
    end
end

return BottomController
