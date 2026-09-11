local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local GuiConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfig)
local CleanupUtil = require(ReplicatedStorage.SharedUtils.CleanupUtil)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local BuildModeController = {}

BuildModeController.CurrentCategory = Vide.source("")

local buildModeGui = LocalPlayerUtil.playerGui.BuildMode

local structureContainer = buildModeGui.StructureContainer
local categoryButtonsFrame = structureContainer.CategoryButtons
local structureBuyList = structureContainer.StructureBuyList
local closeButton = structureContainer.Close

local topButtonContainer = buildModeGui.TopButtonContainer
local deleteButton = topButtonContainer.Delete
local moveButton = topButtonContainer.Move
local rotateButton = topButtonContainer.Rotate
local selectButton = topButtonContainer.Select

local templateFolder = buildModeGui.Template
local structureItem = templateFolder.StructureItem
local structureButton = templateFolder.StructureButton
local structureButtonIconsFolder = templateFolder.StructureButtonIcons
local allIcon = structureButtonIconsFolder.AllIcon
local decorIcon = structureButtonIconsFolder.DecorIcon
local natureIcon = structureButtonIconsFolder.NatureIcon
local specialIcon = structureButtonIconsFolder.SpecialIcon

local STRUCTURE_CONTAINER_DEFAULTS = {
    position = structureContainer.Position;
}
local TOP_BUTTON_CONTAINER_DEFAULTS = {
    position = topButtonContainer.Position;
}

local STRUCTURE_CONTAINER_FOCUS_TWEEN = TweenService:Create(
    structureContainer,
    GuiConfig.MENU_FOCUS_TWEEN_INFO,
    {
        Position = STRUCTURE_CONTAINER_DEFAULTS.position;
    }
)
local STRUCTURE_CONTAINER_DEFOCUS_TWEEN = TweenService:Create(
    structureContainer,
    GuiConfig.MENU_DEFOCUS_TWEEN_INFO,
    {
        Position = STRUCTURE_CONTAINER_DEFAULTS.position + UDim2.fromScale(.5, 0);
    }
)
local TOP_BUTTON_CONTAINER_FOCUS_TWEEN = TweenService:Create(
    topButtonContainer,
    GuiConfig.MENU_DEFOCUS_TWEEN_INFO,
    {
        Position = TOP_BUTTON_CONTAINER_DEFAULTS.position;
    }
)
local TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN = TweenService:Create(
    topButtonContainer,
    GuiConfig.MENU_DEFOCUS_TWEEN_INFO,
    {
        Position = TOP_BUTTON_CONTAINER_DEFAULTS.position + UDim2.fromScale(0, -.5);
    }
)

local CATEGORY_NAMES = {
    All = "All";
    Decor = "Decor";
    Nature = "Nature";
    Special = "Special";
}
local CATEGORY_BUTTONS = {
    { name = CATEGORY_NAMES.All; icon = allIcon };
    { name = CATEGORY_NAMES.Decor; icon = decorIcon };
    { name = CATEGORY_NAMES.Nature; icon = natureIcon };
    { name = CATEGORY_NAMES.Special; icon = specialIcon };
}:: {
    {
        name: string;
        icon: ImageLabel;

        button: GuiButton;
        effects: {
            highlight: {UIStroke | UIGradient | UIShadow};
            default: {UIStroke | UIGradient | UIShadow};
        }
    }
}

local buildModeBin = {}
local currentVideScope

local function createStructureButtons()
    for _, categoryData in CATEGORY_BUTTONS do
        local buttonInstance = structureButton:Clone()
        local structureIconInstance = categoryData.icon:Clone()

        do
            buttonInstance.Name = categoryData.name
            buttonInstance.Parent = categoryButtonsFrame
            buttonInstance.ButtonFrame.StructureName.Text = categoryData.name
            buttonInstance.ButtonFrame.StructureName.LayoutOrder = 1

            structureIconInstance.Parent = buttonInstance.ButtonFrame
            structureIconInstance.LayoutOrder = 0
        end

        categoryData = {
            name = categoryData.name;
            icon = structureIconInstance; -- updated to actual instance

            button = buttonInstance;
            effects = {
                highlight = {
                    buttonInstance.HighlightStroke,
                    buttonInstance.HighlightGradient,
                    buttonInstance.HighlightShadow,
                    buttonInstance.ButtonFrame.HighlightGradient
                };
                default = {
                    buttonInstance.DefaultStroke,
                    buttonInstance.DefaultGradient,
                    buttonInstance.ButtonFrame.DefaultGradient
                };
            }
        }
    end
end

function BuildModeController.Init()
    buildModeGui.Enabled = true

    createStructureButtons()
    BuildModeController.Dismount()
end

function BuildModeController.Mount()
    currentVideScope = Vide.root(function()
        do
            STRUCTURE_CONTAINER_FOCUS_TWEEN:Play()
            TOP_BUTTON_CONTAINER_FOCUS_TWEEN:Play()
        end

        for _, categoryData in CATEGORY_BUTTONS do
            local name = categoryData.name
            local button = categoryData.button
            local effects = categoryData.effects
    
            CleanupUtil.InsertBin(buildModeBin, button.Activated:Connect(function()
                BuildModeController.CurrentCategory(name)
            end))

            Vide.effect(function()
                local isCategorySelected = (BuildModeController.CurrentCategory() == name)

                for _, effect in effects.highlight do
                    effect.Enabled = isCategorySelected
                end
                for _, effect in effects.default do
                    effect.Enabled = not isCategorySelected
                end
            end)
        end
    end)
end

function BuildModeController.Dismount()
    do
        STRUCTURE_CONTAINER_DEFOCUS_TWEEN:Play()
        TOP_BUTTON_CONTAINER_DEFOCUS_TWEEN:Play()
    end

    if currentVideScope then
        currentVideScope()
    end
    CleanupUtil.Clean(buildModeBin)
end

return BuildModeController