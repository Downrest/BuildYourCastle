local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local InterfaceClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)
local TutorialClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.TutorialClientService)
local LocalPlayerUtil = require(game:GetService("StarterPlayer").StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local BottomController = require(script.BottomController)
local LeftController = require(script.LeftController)
local TopController = require(script.TopController)

local InterfaceClientController = {}

local interfaceGui = LocalPlayerUtil.playerGui.Interface

function InterfaceClientController.Init()
    Vide.effect(function()
        local firstFloorReached = InterfaceClientService.IsFirstFloorReached()
        local isInterfaceEnabled = InterfaceClientService.IsInterfaceEnabled()

        LeftController.Toggle(isInterfaceEnabled, true)
        BottomController.Toggle(isInterfaceEnabled, true)
        TopController.Toggle(isInterfaceEnabled and firstFloorReached, true)
    end)

    -- init
    do
        interfaceGui.Enabled = true
    
        TopController.Init()
        LeftController.Init()
        BottomController.Init()

        -- TODO: TEST
        InterfaceClientService.ToggleInterface(true)
    end

    DataSharedService.LocalPlayerDataInitialized:Once(function(replicatedData)
        local floor1Unlocked = replicatedData.attributes.castle.floorUnlocked.floor1

        floor1Unlocked.Changed:Connect(function(
            newUnlock,
            oldUnlock
        )
            if newUnlock then
                warn(`WOWW WE NEED TO DO IT ASAP`)
                InterfaceClientService.SetFirstFloorReached(true)
            end
        end)
    end)

    TutorialClientService.HasTutorialEnded:Once(function()
        InterfaceClientService.ToggleInterface(true)
    end)
end

return InterfaceClientController