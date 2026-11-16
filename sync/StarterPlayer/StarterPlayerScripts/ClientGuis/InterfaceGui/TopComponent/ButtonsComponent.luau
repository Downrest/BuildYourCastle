local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)
local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)

return function(
    gui: InterfaceGuiService.InterfaceGui,
    props: InterfaceGuiService.InterfaceProps
)
    VideUtils.scope(function(bin)
        local topContainer = gui.TopContainer
        local topButtonFrame = topContainer.TopButtonFrame
        local buildButton = topButtonFrame.BuildButton
        
        local BUILD_BUTTON_DEFAULTS = {
            size = buildButton.Size;
        }
        local FOCUS_TWEEN = TweenService:Create(
            buildButton,
            GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
            {
                Size = BUILD_BUTTON_DEFAULTS.size + UDim2.fromScale(.25, .25);
            }
        )
        local DEFOCUS_TWEEN = TweenService:Create(
            buildButton,
            GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
            {
                Size = BUILD_BUTTON_DEFAULTS.size;
            }
        )

        bin:Add(buildButton.MouseEnter:Connect(function()
            FOCUS_TWEEN:Play()
        end))
        bin:Add(buildButton.MouseLeave:Connect(function()
            DEFOCUS_TWEEN:Play()
        end))
        bin:Add(buildButton.Activated:Connect(function()
            props.BuildPressed:Fire()
        end))
    end)
end
