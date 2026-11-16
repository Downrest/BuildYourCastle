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
        local bottomContainer = gui.BottomContainer
        
        local BOTTOM_CONTAINER_DEFAULTS = {
            position = bottomContainer.Position;
        }
        local FOCUS_TWEEN = bin:Add(TweenService:Create(
            bottomContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
            {
                Position = BOTTOM_CONTAINER_DEFAULTS.position;
            }
        ))
        local DEFOCUS_TWEEN = bin:Add(TweenService:Create(
            bottomContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
            {
                Position = BOTTOM_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, .5);
            }
        ))

        Vide.effect(function()
            if props.IsVisible() then
                FOCUS_TWEEN:Play()
            else
                DEFOCUS_TWEEN:Play()
            end
        end)
    end)
end
