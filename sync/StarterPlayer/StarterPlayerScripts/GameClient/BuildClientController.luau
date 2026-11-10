local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local BuildGui = require(StarterPlayer.StarterPlayerScripts.ClientGuis.BuildGui)
local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local GuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.GuiService)
local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local InterfaceConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.InterfaceConfig)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local BuildClientController = {}

function BuildClientController.Init()
    VideUtils.scope(function(bin)
        Vide.mount(
            BuildGui(BuildGuiService),
            GuiService.GUI
        )

        Vide.effect(function()
            BuildGuiService.IsVisible(
                InterfaceClientService.CurrentGui() == InterfaceConfig.GUIS.Build
            )
        end)

        bin:Add(BuildGuiService.ExitPressed:Connect(function()
            InterfaceClientService.Enter(
                InterfaceConfig.GUIS.Interface
            )
        end))
    end)
end

return BuildClientController
