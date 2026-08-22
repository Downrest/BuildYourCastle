local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local TopController = {}

local interfaceGui = LocalPlayerUtil.playerGui.Interface
local topContainer = interfaceGui.TopContainer

local TOP_CONTAINER_DEFAULTS = {
    position = topContainer.Position;
}
local TOP_FOCUS_POSITION = TOP_CONTAINER_DEFAULTS.position
local TOP_DEFOCUS_POSITION = TOP_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, -3)

local topFocusTween = TweenService:Create(
    topContainer,
    GuiConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = TOP_FOCUS_POSITION;
    }
)
local topDefocusTween = TweenService:Create(
    topContainer,
    GuiConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = TOP_DEFOCUS_POSITION;
    }
)

function TopController.Init()
    TopController.Toggle(false)
end

function TopController.Toggle(isFocused: boolean, isAnimated: boolean?)
    if isFocused then
        if isAnimated then
            topFocusTween:Play()
        else
            topContainer.Position = TOP_FOCUS_POSITION
        end
    else
        if isAnimated then
            topDefocusTween:Play()
        else
            topContainer.Position = TOP_DEFOCUS_POSITION
        end
    end
end

return TopController
