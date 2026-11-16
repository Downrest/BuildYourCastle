local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.InterfaceConfig)
local BuildGui = require(StarterPlayer.StarterPlayerScripts.ClientGuis.BuildGui)
local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)
local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local GuiController = {}

function GuiController.Init()
    Vide.mount(
        BuildGui(BuildGuiService),
        GuiClientService.GUI_ROOT
    )

    Vide.effect(function()
        BuildGuiService.IsVisible(
            InterfaceClientService.CurrentGui() == InterfaceConfig.GUIS.Build
        )
    end)

    BuildGuiService.ExitPressed:Connect(function()
        InterfaceClientService.Exit(
            InterfaceConfig.GUIS.Interface
        )
    end)
end

return GuiController
