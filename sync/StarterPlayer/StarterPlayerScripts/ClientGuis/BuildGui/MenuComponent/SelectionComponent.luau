local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")

local GuiTweenConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.GuiConfigs.GuiTweenConfig)
local BuildConfig = require(ReplicatedStorage.SharedConfigs.CastleConfig.BuildConfig)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local ViewportUtil = require(ReplicatedStorage.SharedUtils.ViewportUtil)
local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)

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

return function(
    gui: BuildGuiService.BuildGui,
    props: BuildGuiService.BuildProps
)
    VideUtils.scope(function(bin)
        local buildContainer = gui.BuildContainer
        local categoryButtonsFrame = buildContainer.CategoryButtons
        local buildBuyFrame = buildContainer.BuildBuyFrame
        local closeButton = buildContainer.Close

        local templateFolder = gui.Template
        local buildBuyList = templateFolder.BuildBuyList
        local buildItemBuy = templateFolder.BuildItemBuy
        local buildCategoryButton = templateFolder.BuildCategoryButton
        local buildButtonIconsFolder = templateFolder.BuildButtonIcons
        local allIcon = buildButtonIconsFolder.AllIcon
        local decorIcon = buildButtonIconsFolder.DecorIcon
        local natureIcon = buildButtonIconsFolder.NatureIcon
        local specialIcon = buildButtonIconsFolder.SpecialIcon

        local MENU_CLOSE_DEFAULTS = {
            size = closeButton.Size;
            rotation = closeButton.Rotation;
        }
        local MENU_CLOSE_TWEENS = {
            focus = bin:Add(TweenService:Create(
                closeButton,
                GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
                {
                    Size = MENU_CLOSE_DEFAULTS.size + UDim2.fromScale(.01, .01);
                    Rotation = MENU_CLOSE_DEFAULTS.rotation + 3;
                }
            ));
            defocus = bin:Add(TweenService:Create(
                closeButton,
                GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO,
                {
                    Size = MENU_CLOSE_DEFAULTS.size;
                    Rotation = MENU_CLOSE_DEFAULTS.rotation;
                }
            ))
        }

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

        local function createBuildBuyButtons(
            buttonCallback: (
                button: GuiButton,
                buttonProps: {
                    buyList: ScrollingFrame;
                    categoryName: string;
                    buildName: string;
                }
            ) -> ()
        )
            for _, categoryName in CATEGORY_ORDER:: {string} do
                local buyList = buildBuyList:Clone(); do
                    buyList.Name = categoryName
                    buyList.Visible = true
                    buyList.Parent = buildBuyFrame
                end
        
                -- process builds
                do
                    for _, buildName in BuildConfig.CATEGORY_TO_BUILDS[categoryName]:: {[string]: string} do
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
            
                        buttonCallback(
                            buildItemBuy,
                            {
                                buyList = buyList;
                                categoryName = categoryName;
                                buildName = buildName;
                            }
                        )
                    end
                end
            end
        end

        local function createCategoryButtons(
            categoryCallback: (
                button: GuiButton,
                buttonProps: {
                    categoryName: string;
                    icon: ImageLabel;
                    effects: {
                        highlight: {UIStroke | UIGradient | UIShadow};
                        default: {UIStroke | UIGradient | UIShadow};
                    }
                }
            ) -> ()
        )
            for _, categoryName in CATEGORY_ORDER:: {string} do
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

                categoryCallback(
                    buttonInstance,
                    {
                        categoryName = categoryName;
                        icon = buildIconInstance;
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
                )
            end
        end

        -- category buttons
        createCategoryButtons(function(
            button,
            buttonProps
        )
            local effects = buttonProps.effects

            bin:Add(button.Activated:Connect(function()
                props.CurrentCategory(buttonProps.categoryName)
            end))

            Vide.effect(function()
                local isCategorySelected = (props.CurrentCategory() == buttonProps.categoryName)

                button.AutoButtonColor = not isCategorySelected
                for _, effect in effects.highlight do
                    effect.Enabled = isCategorySelected
                end
                for _, effect in effects.default do
                    effect.Enabled = not isCategorySelected
                end
            end)
        end)

        -- build buy buttons (per category)
        createBuildBuyButtons(function(
            button,
            buttonProps
        )
            bin:Add(button.Activated:Connect(function()
                props.CurrentBuildSelection(buttonProps.buildName)
            end))

            Vide.effect(function()
                local isCategory = (props.CurrentCategory() == buttonProps.categoryName)

                buttonProps.buyList.Visible = isCategory
            end)
        end)

        -- close button
        do
            bin:Add(closeButton.MouseEnter:Connect(function()
                MENU_CLOSE_TWEENS.focus:Play()
            end))
            bin:Add(closeButton.MouseLeave:Connect(function()
                MENU_CLOSE_TWEENS.defocus:Play()
            end))
            bin:Add(closeButton.Activated:Connect(function()
                props.ExitPressed:Fire()
            end))

            -- reset
            bin:Add(function()
                MENU_CLOSE_TWEENS.defocus:Play()
            end)
        end
    end)
end
