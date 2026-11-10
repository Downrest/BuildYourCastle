local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)

local TopButtonController = {}

type SelectionButton = GuiButton & {
    Icon: ImageLabel
}
type IconProperties = {
    rotation: number;
    position: UDim2;
}

local buildModeGui = GuiClientService.BuildMode

local topButtonContainer = buildModeGui.TopButtonContainer
local deleteButton = topButtonContainer.Delete
local moveButton = topButtonContainer.Move
local rotateButton = topButtonContainer.Rotate
local selectButton = topButtonContainer.Select

local TOP_BUTTON_CONTAINER_DEFAULTS = {
    position = topButtonContainer.Position;
}

local TOP_BUTTON_CONTAINER_FOCUS_TWEEN = TweenService:Create(
    topButtonContainer,
    GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = TOP_BUTTON_CONTAINER_DEFAULTS.position;
    }
)
local TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN = TweenService:Create(
    topButtonContainer,
    GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = TOP_BUTTON_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, -.5);
    }
)

local SELECT_ICON_DEFAULTS = {
    rotation = selectButton.Icon.Rotation;
}:: IconProperties
local SELECT_ICON_HOVER = {
    rotation = SELECT_ICON_DEFAULTS.rotation + -15;
}:: IconProperties
local MOVE_ICON_DEFAULTS = {
    rotation = moveButton.Icon.Rotation;
    position = moveButton.Icon.Position;
}:: IconProperties
local MOVE_ICON_HOVER = {
    rotation = MOVE_ICON_DEFAULTS.rotation + 15;
    position = MOVE_ICON_DEFAULTS.position + UDim2.fromScale(0, -.05);
}:: IconProperties
local ROTATE_ICON_DEFAULTS = {
    rotation = rotateButton.Icon.Rotation;
}:: IconProperties
local ROTATE_ICON_HOVER = {
    rotation = rotateButton.Icon.Rotation + -15;
}:: IconProperties
local DELETE_ICON_DEFAULTS = {
    rotation = deleteButton.Icon.Rotation;
    position = deleteButton.Icon.Position;
}:: IconProperties
local DELETE_ICON_HOVER = {
    rotation = deleteButton.Icon.Rotation + 15;
    position = DELETE_ICON_DEFAULTS.position + UDim2.fromScale(0, .05);
}:: IconProperties

local DEFAULT_SELECTION_BUTTON_SIZE = UDim2.fromScale(1, 1)
local HOVER_SELECTION_BUTTON_SIZE = UDim2.fromScale(1.15, 1.15)

local topButtonBin = Janitor.new()

local buttonFocusTweenCache = {}:: {[GuiButton]: () -> ()}
local buttonDefocusTweenCache = {}:: {[GuiButton]: () -> ()}

local function cacheSelectionTweens(button: GuiButton, focusIconProperties: IconProperties, defocusIconProperties: IconProperties)
    button = (button:: SelectionButton)

    local focusTween = TweenService:Create(
        button, 
        GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
        {
            Size = HOVER_SELECTION_BUTTON_SIZE;
        }
    )
    local focusIconTween = TweenService:Create(
        button.Icon, 
        GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
        {
            Rotation = focusIconProperties.rotation;
            Position = focusIconProperties.position;
        }
    )
    local defocusTween = TweenService:Create(
        button, 
        GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
        {
            Size = DEFAULT_SELECTION_BUTTON_SIZE;
        }
    )
    local defocusIconTween = TweenService:Create(
        button.Icon, 
        GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO,
        {
            Rotation = defocusIconProperties.rotation;
            Position = defocusIconProperties.position;
        }
    )

    buttonFocusTweenCache[button] = function()
        focusTween:Play()
        focusIconTween:Play()
    end
    buttonDefocusTweenCache[button] = function()
        defocusTween:Play()
        defocusIconTween:Play()
    end
end

local function onSelectionActivated(button: GuiButton, buttonSelection: string)
    topButtonBin:Add(button.MouseEnter:Connect(function()
        buttonFocusTweenCache[button]()
    end))
    topButtonBin:Add(button.MouseLeave:Connect(function()
        buttonDefocusTweenCache[button]()
    end))

    topButtonBin:Add(button.Activated:Connect(function()
        BuildClientService.CurrentButtonSelection(buttonSelection)
    end))
end

function TopButtonController.Init()
    do
        cacheSelectionTweens(deleteButton, DELETE_ICON_HOVER, DELETE_ICON_DEFAULTS)
        cacheSelectionTweens(moveButton, MOVE_ICON_HOVER, MOVE_ICON_DEFAULTS)
        cacheSelectionTweens(rotateButton, ROTATE_ICON_HOVER, ROTATE_ICON_DEFAULTS)
        cacheSelectionTweens(selectButton, SELECT_ICON_HOVER, SELECT_ICON_DEFAULTS)
    end

    TopButtonController.Dismount()
end

function TopButtonController.Mount()
    TOP_BUTTON_CONTAINER_FOCUS_TWEEN:Play()

    do
        onSelectionActivated(deleteButton, BuildClientService.BUTTON_SELECTIONS.Delete)
        onSelectionActivated(moveButton, BuildClientService.BUTTON_SELECTIONS.Move)
        onSelectionActivated(rotateButton, BuildClientService.BUTTON_SELECTIONS.Rotate)
        onSelectionActivated(selectButton, BuildClientService.BUTTON_SELECTIONS.Select)
    end
end

function TopButtonController.Dismount()
    do
        TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN:Play()
    end

    topButtonBin:Cleanup()
end

return TopButtonController
