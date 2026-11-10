local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)

return function(
    gui: BuildGuiService.BuildGui,
    props: BuildGuiService.BuildProps
)
    VideUtils.scope(function(bin)
        local buildContainer = gui.BuildContainer

        local BUILD_CONTAINER_DEFAULTS = {
            position = buildContainer.Position;
        }
        local BUILD_CONTAINER_FOCUS_TWEEN = bin:Add(TweenService:Create(
            buildContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
            {
                Position = BUILD_CONTAINER_DEFAULTS.position;
            }
        ))
        local BUILD_CONTAINER_DEFOCUS_TWEEN = bin:Add(TweenService:Create(
            buildContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
            {
                Position = BUILD_CONTAINER_DEFAULTS.position + UDim2.fromScale(.5, 0);
            }
        ))

        Vide.effect(function()
            if props.IsVisible() then
                BUILD_CONTAINER_FOCUS_TWEEN:Play()
            else
                BUILD_CONTAINER_DEFOCUS_TWEEN:Play()
            end
        end)
    end)
end
