local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)

type SelectionButton = GuiButton & { Icon: ImageLabel }
type IconTweenProperties = {
    rotation: number;
    position: UDim2;
}

return function(
	gui: BuildGuiService.BuildGui,
	props: BuildGuiService.BuildProps
)
    VideUtils.scope(function(bin)
        local topButtonContainer = gui.TopButtonContainer

        local deleteButton = topButtonContainer.Delete
        local moveButton = topButtonContainer.Move
        local rotateButton = topButtonContainer.Rotate
        local selectButton = topButtonContainer.Select

        local DEFAULT_SELECTION_BUTTON_SIZE = UDim2.fromScale(1, 1)
        local HOVER_SELECTION_BUTTON_SIZE = UDim2.fromScale(1.15, 1.15)

        local DELETE_ICON_DEFAULTS = {
            rotation = deleteButton.Icon.Rotation;
            position = deleteButton.Icon.Position;
        }
        local DELETE_ICON_HOVER = {
            rotation = DELETE_ICON_DEFAULTS.rotation + 15;
            position = DELETE_ICON_DEFAULTS.position + UDim2.fromScale(0, .05);
        }
        local MOVE_ICON_DEFAULTS = {
            rotation = moveButton.Icon.Rotation;
            position = moveButton.Icon.Position;
        }
        local MOVE_ICON_HOVER = {
            rotation = MOVE_ICON_DEFAULTS.rotation + 15;
            position = MOVE_ICON_DEFAULTS.position + UDim2.fromScale(0, -.05);
        }
        local ROTATE_ICON_DEFAULTS = {
            rotation = rotateButton.Icon.Rotation;
            position = rotateButton.Icon.Position;
        }
        local ROTATE_ICON_HOVER = {
            rotation = ROTATE_ICON_DEFAULTS.rotation - 15;
            position = ROTATE_ICON_DEFAULTS.position;
        }
        local SELECT_ICON_DEFAULTS = {
            rotation = selectButton.Icon.Rotation;
            position = selectButton.Icon.Position;
        }
        local SELECT_ICON_HOVER = {
            rotation = SELECT_ICON_DEFAULTS.rotation - 15;
            position = SELECT_ICON_DEFAULTS.position;
        }

        local TOP_BUTTON_CONTAINER_DEFAULTS = {
            position = topButtonContainer.Position;
        }
        local TOP_BUTTON_CONTAINER_FOCUS_TWEEN = bin:Add(TweenService:Create(
            topButtonContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
            { Position = TOP_BUTTON_CONTAINER_DEFAULTS.position }
        ))
        local TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN = bin:Add(TweenService:Create(
            topButtonContainer,
            GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
            { Position = TOP_BUTTON_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, -.5) }
        ))

        
        local function onSelectionActivated(
            button: GuiButton,
            selection: string,
            tweenData: {
                focus: IconTweenProperties;
                defocus: IconTweenProperties;
            }
        )
            local selectionButton = button :: SelectionButton

            local focusButtonTween = bin:Add(TweenService:Create(
                selectionButton,
                GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
                { Size = HOVER_SELECTION_BUTTON_SIZE }
            ))
            local focusIconTween = bin:Add(TweenService:Create(
                selectionButton.Icon,
                GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
                {
                    Rotation = tweenData.focus.rotation;
                    Position = tweenData.focus.position;
                }
            ))
            local defocusButtonTween = bin:Add(TweenService:Create(
                selectionButton,
                GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
                { Size = DEFAULT_SELECTION_BUTTON_SIZE }
            ))
            local defocusIconTween = bin:Add(TweenService:Create(
                selectionButton.Icon,
                GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
                {
                    Rotation = tweenData.defocus.rotation;
                    Position = tweenData.defocus.position;
                }
            ))

            bin:Add(selectionButton.MouseEnter:Connect(function()
                focusButtonTween:Play()
                focusIconTween:Play()
            end))
            bin:Add(selectionButton.MouseLeave:Connect(function()
                defocusButtonTween:Play()
                defocusIconTween:Play()
            end))
            bin:Add(selectionButton.Activated:Connect(function()
                props.CurrentMode(selection)
            end))

            -- reset on cleanup
            bin:Add(function()
                defocusButtonTween:Play()
                defocusIconTween:Play()
            end)
        end

        -- mode buttons
        do
            onSelectionActivated(deleteButton, BuildGuiService.BUTTON_SELECTIONS.Delete, {
                focus = DELETE_ICON_HOVER;
                defocus = DELETE_ICON_DEFAULTS;
            })
            onSelectionActivated(moveButton, BuildGuiService.BUTTON_SELECTIONS.Move, {
                focus = MOVE_ICON_HOVER;
                defocus = MOVE_ICON_DEFAULTS;
            })
            onSelectionActivated(rotateButton, BuildGuiService.BUTTON_SELECTIONS.Rotate, {
                focus = ROTATE_ICON_HOVER;
                defocus = ROTATE_ICON_DEFAULTS;
            })
            onSelectionActivated(selectButton, BuildGuiService.BUTTON_SELECTIONS.Select, {
                focus = SELECT_ICON_HOVER;
                defocus = SELECT_ICON_DEFAULTS;
            })
        end

        Vide.effect(function()
            if props.IsVisible() then
                TOP_BUTTON_CONTAINER_FOCUS_TWEEN:Play()
            else
                TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN:Play()
            end
        end)
    end)
end
