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
local BOTTOM_DEFOCUS_POSITION = BOTTOM_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, 3)

local bottomFocusTween = TweenService:Create(
    bottomContainer,
    GuiConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = BOTTOM_FOCUS_POSITION;
    }
)
local bottomDefocusTween = TweenService:Create(
    bottomContainer,
    GuiConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = BOTTOM_DEFOCUS_POSITION;
    }
)

function BottomController.Init()
    BottomController.Toggle(false)
end

function BottomController.Toggle(isFocused: boolean, isAnimated: boolean?)
    if isFocused then
        if isAnimated then
            bottomFocusTween:Play()
        else
            bottomContainer.Position = BOTTOM_FOCUS_POSITION
        end
    else
        if isAnimated then
            bottomDefocusTween:Play()
        else
            bottomContainer.Position = BOTTOM_DEFOCUS_POSITION
        end
    end
end

return BottomController
