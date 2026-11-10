local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local CastleClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.CastleClientService)
local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local TutorialClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.TutorialClientService)

local BottomController = require(script.BottomController)
local LeftController = require(script.LeftController)
local TopController = require(script.TopController)

local InterfaceClientController = {}

local interfaceGui = GuiClientService.Interface

function InterfaceClientController.Init()
    -- init
    do
        interfaceGui.Enabled = true
    
        TopController.Init()
        LeftController.Init()
        BottomController.Init()
    end

    -- first floor reached
    Vide.effect(function()
        if CastleClientService.IsFirstFloorUnlocked() then
            InterfaceClientService.IsFirstFloorReached(true)
        end
    end)

    -- interface toggling
    Vide.effect(function()
        local firstFloorReached = InterfaceClientService.IsFirstFloorReached()
        local isInterfaceEnabled = InterfaceClientService.IsInterfaceEnabled()

        local isGameFirstlyIntroduced = Vide.untrack(InterfaceClientService.GameFirstlyIntroduced)

        LeftController.Toggle(isInterfaceEnabled, isGameFirstlyIntroduced)
        BottomController.Toggle(isInterfaceEnabled, isGameFirstlyIntroduced)
        TopController.Toggle(isInterfaceEnabled and firstFloorReached, isGameFirstlyIntroduced)
    end)

    -- tutorial finished
    Vide.effect(function()
        if not TutorialClientService.TutorialFinished() then
            return
        end

        InterfaceClientService.IsInterfaceEnabled(true)
        InterfaceClientService.GameFirstlyIntroduced(false)
    end)
end

return InterfaceClientController