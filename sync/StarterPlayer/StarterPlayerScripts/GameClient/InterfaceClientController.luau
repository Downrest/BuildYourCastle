local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local TutorialClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.TutorialClientService)
local LocalPlayerUtil = require(game:GetService("StarterPlayer").StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local BottomController = require(script.BottomController)
local LeftController = require(script.LeftController)
local TopController = require(script.TopController)

local InterfaceClientController = {}

local interfaceGui = LocalPlayerUtil.playerGui.Interface

function InterfaceClientController.Init()
    -- init
    do
        interfaceGui.Enabled = true
    
        TopController.Init()
        LeftController.Init()
        BottomController.Init()

        --TODO: add a field in each player data for checking if theyve gotten past the first cutscene
        InterfaceClientService.GameFirstlyIntroduced(true)

        -- TODO: TEST
        InterfaceClientService.IsInterfaceEnabled(true)
    end

    -- first floor reached
    DataClientService.PlayerState.castle.floorUnlocked.floor1.Observed(function(newUnlock, oldUnlock)
        if newUnlock then
            InterfaceClientService.IsFirstFloorReached(true)
        end
    end)

    -- interface toggling
    Vide.effect(function()
        local firstFloorReached = InterfaceClientService.IsFirstFloorReached()
        local isInterfaceEnabled = InterfaceClientService.IsInterfaceEnabled()

        local isGameFirstlyIntroduced = Vide.untrack(InterfaceClientService.GameFirstlyIntroduced)

        warn(`TOGGLING... IS SLOW? {isGameFirstlyIntroduced}`)
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