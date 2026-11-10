local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)
local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)

return function(
    gui: InterfaceGuiService.InterfaceGui,
    props: InterfaceGuiService.InterfaceProps
)
    VideUtils.scope(function(bin)
        local topContainer = gui.TopContainer
        local buttonFrame = topContainer.TopButtonFrame

        local TOP_CONTAINER_DEFAULTS = {
            position = topContainer.Position;
        }
        local TOP_CONTAINER_FOCUS_TWEEN = TweenService:Create(
            topContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
            {
                Position = TOP_CONTAINER_DEFAULTS.position;
            }
        )
        local TOP_CONTAINER_DEFOCUS_TWEEN = TweenService:Create(
            topContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
            {
                Position = TOP_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, -.5);
            }
        )
        local BUTTON_DATA = {
            [buttonFrame.BuildButton] = {
                signal = props.BuildPressed;
            };
        }
    
        local function processButtonFocus(button: GuiButton, signal: Signal.Signal)
            local BUTTON_DEFAULTS = {
                size = button.Size;
            }
            local FOCUS_TWEEN = TweenService:Create(
                button,
                GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
                {
                    Size = BUTTON_DEFAULTS.size + UDim2.fromScale(.25, .25);
                }
            )
            local DEFOCUS_TWEEN = TweenService:Create(
                button,
                GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
                {
                    Size = BUTTON_DEFAULTS.size;
                }
            )

            bin:Add(button.MouseEnter:Connect(function()
                FOCUS_TWEEN:Play()
            end))
            bin:Add(button.MouseLeave:Connect(function()
                DEFOCUS_TWEEN:Play()
            end))
            bin:Add(button.Activated:Connect(function()
                signal:Fire()
            end))
        end

        -- top visible anim
        Vide.effect(function()
            if props.IsVisible() then
                TOP_CONTAINER_FOCUS_TWEEN:Play()
            else
                TOP_CONTAINER_DEFOCUS_TWEEN:Play()
            end
        end)

        -- button focus anims
        do
            for button, data in BUTTON_DATA do
                processButtonFocus(button, data.signal)
            end
        end
    end)
end
