local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local BuildConfig = require(ReplicatedStorage.SharedConfigs.CastleConfig.BuildConfig)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local ViewportUtil = require(ReplicatedStorage.SharedUtils.ViewportUtil)
local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)

local BuildController = {}

type CategoryButton = {
    icon: ImageLabel;

    button: GuiButton;
    effects: {
        highlight: {UIStroke | UIGradient | UIShadow};
        default: {UIStroke | UIGradient | UIShadow};
    }
}

type BuildData = {
    buyButton: GuiButton;
}
type CategoryBuildList = {
    buyList: ScrollingFrame;
    builds: {[string]: BuildData};
}

local buildModeGui = GuiClientService.BuildMode

local buildContainer = buildModeGui.BuildContainer
local categoryButtonsFrame = buildContainer.CategoryButtons
local buildBuyFrame = buildContainer.BuildBuyFrame
local closeButton = buildContainer.Close

local templateFolder = buildModeGui.Template
local buildBuyList = templateFolder.BuildBuyList
local buildItemBuy = templateFolder.BuildItemBuy
local buildCategoryButton = templateFolder.BuildCategoryButton
local buildButtonIconsFolder = templateFolder.BuildButtonIcons
local allIcon = buildButtonIconsFolder.AllIcon
local decorIcon = buildButtonIconsFolder.DecorIcon
local natureIcon = buildButtonIconsFolder.NatureIcon
local specialIcon = buildButtonIconsFolder.SpecialIcon

local STRUCTURE_CONTAINER_DEFAULTS = {
    position = buildContainer.Position;
}
local STRUCTURE_CONTAINER_FOCUS_TWEEN = TweenService:Create(
    buildContainer,
    GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO,
    {
        Position = STRUCTURE_CONTAINER_DEFAULTS.position;
    }
)
local STRUCTURE_CONTAINER_DEFOCUS_TWEEN = TweenService:Create(
    buildContainer,
    GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO,
    {
        Position = STRUCTURE_CONTAINER_DEFAULTS.position + UDim2.fromScale(.5, 0);
    }
)

local CATEGORY_TO_ICONS = {
    [BuildConfig.CATEGORY_NAMES.All] = allIcon;
    [BuildConfig.CATEGORY_NAMES.Decor] = decorIcon;
    [BuildConfig.CATEGORY_NAMES.Nature] = natureIcon;
    [BuildConfig.CATEGORY_NAMES.Special] = specialIcon;
}
local CATEGORY_ORDER = {
    BuildConfig.CATEGORY_NAMES.All;
    BuildConfig.CATEGORY_NAMES.Decor;
    BuildConfig.CATEGORY_NAMES.Nature;
    BuildConfig.CATEGORY_NAMES.Special;
}
local VIEWPORT_CONFIG = ViewportUtil.config({
    orientation = CFrame.Angles(0, math.rad(-15), 0);
})

local categoryButtons = {}:: {[string]: CategoryButton}
local categoryBuilds = {}:: {[string]: CategoryBuildList}

local buildModeBin = Janitor.new()

local function createBuildBuyButtons()
    local builds = {}:: {[string]: BuildData}
    
    for _, categoryName in CATEGORY_ORDER do
        local buyList = buildBuyList:Clone(); do
            buyList.Name = categoryName
            buyList.Visible = true
            buyList.Parent = buildBuyFrame
        end

        -- process builds
        do
            for _, buildName in BuildConfig.CATEGORY_TO_BUILDS[categoryName] do
                local buildItemBuy = buildItemBuy:Clone(); do
                    buildItemBuy.LayoutOrder = BuildConfig.BUILD_TO_LIST_ORDER[buildName]
                    buildItemBuy.Visible = true
                    buildItemBuy.Name = buildName
                    buildItemBuy.Parent = buyList
                    buildItemBuy.Title.Text = BuildConfig.BUILD_TO_PUBLIC_NAME[buildName]

                    -- viewport
                    do
                        local viewport = buildItemBuy.ViewportIcon
                        local viewportCamera = Instance.new("Camera"); do
                            viewport.CurrentCamera = viewportCamera
                        end
                        local itemModel = BuildConfig.BUILD_TO_ASSET[buildName]:Clone()

                        itemModel:PivotTo(
                            VIEWPORT_CONFIG.FitCFrame(viewportCamera, viewport, itemModel)
                        )
                        itemModel.Parent = viewport
                    end
                end
    
                builds[buildName] = {
                    buyButton = buildItemBuy;
                }
            end
        end

        categoryBuilds[categoryName] = {
            buyList = buyList;
            builds = builds;
        }
    end
end

local function createCategoryButtons()
    for _, categoryName in CATEGORY_ORDER do
        local buttonInstance = buildCategoryButton:Clone(); do
            buttonInstance.Name = categoryName
            buttonInstance.Parent = categoryButtonsFrame
            buttonInstance.ButtonFrame.CategoryName.Text = categoryName
            buttonInstance.ButtonFrame.CategoryName.LayoutOrder = 1
            buttonInstance.Visible = true
        end
        local buildIconInstance = CATEGORY_TO_ICONS[categoryName]:Clone(); do
            buildIconInstance.Parent = buttonInstance.ButtonFrame
            buildIconInstance.LayoutOrder = 0
            buildIconInstance.Visible = true
        end

        categoryButtons[categoryName] = {
            icon = buildIconInstance; -- updated to actual instance

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

function BuildController.Init()
    createBuildBuyButtons()
    createCategoryButtons()

    BuildController.Dismount()
end

function BuildController.Mount()
    STRUCTURE_CONTAINER_FOCUS_TWEEN:Play()

    -- builds
    do
        for categoryName, listData in categoryBuilds do
            for buildName, buildData in listData.builds do
                buildModeBin:Add(buildData.buyButton.Activated:Connect(function()
                    warn("CLICKED")
                    BuildClientService.CurrentBuildSelected(buildName)
                end))
            end
        end
    end

    -- categories
    do
        for categoryName, categoryData in categoryButtons do
            local button = categoryData.button
            local effects = categoryData.effects
    
            buildModeBin:Add(button.Activated:Connect(function()
                BuildClientService.CurrentCategory(categoryName)
            end))
    
            buildModeBin:Add(Vide.root(function()
                Vide.effect(function()
                    local isCategorySelected = (BuildClientService.CurrentCategory() == categoryName)
        
                    button.AutoButtonColor = not isCategorySelected
                    for _, effect in effects.highlight do
                        effect.Enabled = isCategorySelected
                    end
                    for _, effect in effects.default do
                        effect.Enabled = not isCategorySelected
                    end
                end)
            end))
        end

        buildModeBin:Add(Vide.root(function()
            Vide.effect(function()
                local currentCategory = BuildClientService.CurrentCategory()

                for categoryName, listData in categoryBuilds do
                    local isCategory = (currentCategory == categoryName)

                    listData.buyList.Visible = isCategory
                end
            end)
        end))
    end

    -- close button
    do
        buildModeBin:Add(closeButton.Activated:Connect(function()
            BuildClientService.IsBuildMode(false)
        end))
    end
end

function BuildController.Dismount()
    do
        STRUCTURE_CONTAINER_DEFOCUS_TWEEN:Play()
    end

    buildModeBin:Cleanup()
end

return BuildController
