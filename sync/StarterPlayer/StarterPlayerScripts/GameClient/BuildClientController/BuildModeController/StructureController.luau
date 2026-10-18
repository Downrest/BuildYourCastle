local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)

local StructureController = {}

local buildModeGui = LocalPlayerUtil.playerGui.BuildMode

local structureContainer = buildModeGui.StructureContainer
local categoryButtonsFrame = structureContainer.CategoryButtons
local structureBuyList = structureContainer.StructureBuyList
local closeButton = structureContainer.Close

local templateFolder = buildModeGui.Template
local structureItem = templateFolder.StructureItem
local structureButton = templateFolder.StructureButton
local structureButtonIconsFolder = templateFolder.StructureButtonIcons
local allIcon = structureButtonIconsFolder.AllIcon
local decorIcon = structureButtonIconsFolder.DecorIcon
local natureIcon = structureButtonIconsFolder.NatureIcon
local specialIcon = structureButtonIconsFolder.SpecialIcon

-- we procedurally fill out the rest of data: button, effects, etc
local CATEGORY_BUTTONS = {
    { name = BuildClientService.CATEGORY_NAMES.All; icon = allIcon };
    { name = BuildClientService.CATEGORY_NAMES.Decor; icon = decorIcon };
    { name = BuildClientService.CATEGORY_NAMES.Nature; icon = natureIcon };
    { name = BuildClientService.CATEGORY_NAMES.Special; icon = specialIcon };
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

local structureBin = Janitor.new()

local function initCategoryButtons()
    for categoryIndex, categoryData in CATEGORY_BUTTONS do
        local categoryName = categoryData.name

        local buttonInstance = structureButton:Clone(); do
            buttonInstance.Name = categoryName
            buttonInstance.ButtonFrame.StructureName.Text = categoryName
            buttonInstance.ButtonFrame.StructureName.LayoutOrder = 1
            buttonInstance.Visible = true
            buttonInstance.Parent = categoryButtonsFrame
        end
        local structureIconInstance = categoryData.icon:Clone(); do
            structureIconInstance.LayoutOrder = 0
            structureIconInstance.Visible = true
            structureIconInstance.Parent = buttonInstance.ButtonFrame
        end
        local effects = {
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

        structureBin:Add(buttonInstance.Activated:Connect(function()
            BuildClientService.CurrentCategory(categoryName)
        end))

        Vide.effect(function()
            local isCategorySelected = (BuildClientService.CurrentCategory() == categoryName)

            buttonInstance.AutoButtonColor = not isCategorySelected
            for _, effect in effects.highlight do
                effect.Enabled = isCategorySelected
            end
            for _, effect in effects.default do
                effect.Enabled = not isCategorySelected
            end
        end)
    end
end

local function initCloseButton()
    structureBin:Add(closeButton.Activated:Connect(function()
        BuildClientService.IsBuildMode(false)
    end))
end

function StructureController.Mount()
    --TODO: bring back old button table
    initCategoryButtons()
    initCloseButton()
end

function StructureController.Dismount()
    structureBin:Cleanup()
end

return StructureController