local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.InterfaceConfig)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local InterfaceGui = require(StarterPlayer.StarterPlayerScripts.ClientGuis.InterfaceGui)
local GuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.GuiService)
local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)
local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local InterfaceClientController = {}

function InterfaceClientController.Init()
    VideUtils.scope(function(bin)
        Vide.mount(
            InterfaceGui(InterfaceGuiService), 
            GuiService.GUI
        )

        Vide.effect(function()
            InterfaceGuiService.IsVisible(
                InterfaceClientService.CurrentGui() == InterfaceConfig.GUIS.Interface
            )
        end)

        -- buttons
        do
            bin:Add(InterfaceGuiService.BuildPressed:Connect(function()
                InterfaceClientService.Enter(InterfaceConfig.GUIS.Build)
            end))
        end
    end)
end

return InterfaceClientController
