local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.InterfaceConfig)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local InterfaceGui = require(StarterPlayer.StarterPlayerScripts.ClientGuis.InterfaceGui)
local CurrencyClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.CurrencyClientService)
local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)
local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)
local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local LoadingClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.LoadingClientService)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local InterfaceClientController = {}

function InterfaceClientController.Init()
    VideUtils.scope(function(bin)
        Vide.mount(
            InterfaceGui(InterfaceGuiService), 
            GuiClientService.GUI_ROOT
        )

        Vide.effect(function()
            InterfaceGuiService.IsVisible(
                -- check if loaded
                LoadingClientService.IsLoaded()

                and InterfaceClientService.CurrentGui() == InterfaceConfig.GUIS.Interface
            )
        end)

        -- currency
        do
            Vide.effect(function()
                local previousGold = Vide.untrack(InterfaceGuiService.CurrentGold)

                InterfaceGuiService.CurrentGold(
                    CurrencyClientService.Gold()
                )
                InterfaceGuiService.PreviousGold(
                    previousGold
                )
            end)
        end

        -- buttons
        do
            bin:Add(InterfaceGuiService.BuildPressed:Connect(function()
                InterfaceClientService.Enter(InterfaceConfig.GUIS.Build)
            end))
        end
    end)
end

return InterfaceClientController
