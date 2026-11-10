local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)
local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)

return function(
    gui: InterfaceGuiService.InterfaceGui,
    props: InterfaceGuiService.InterfaceProps
)
    VideUtils.scope(function(bin)
        local leftContainer = gui.LeftContainer

        local LEFT_CONTAINER_DEFAULTS = {
            position = leftContainer.Position;
        }
        local LEFT_FOCUS_TWEEN = bin:Add(TweenService:Create(
            leftContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
            {
                Position = LEFT_CONTAINER_DEFAULTS.position;
            }
        ))
        local LEFT_DEFOCUS_TWEEN = bin:Add(TweenService:Create(
            leftContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
            {
                Position = LEFT_CONTAINER_DEFAULTS.position + UDim2.fromScale(-.5, 0);
            }
        ))

        -- left visible anim
        Vide.effect(function()
            if props.IsVisible() then
                LEFT_FOCUS_TWEEN:Play()
            else
                LEFT_DEFOCUS_TWEEN:Play()
            end
        end)
    end)
end
