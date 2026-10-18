local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local GuiController = require(script.GuiController)

local HintClientController = {}

function HintClientController.Init()
    GuiController.Init()

    DataClientService.PlayerState.castle.floorUnlocked.floor1.Observed(function(newUnlock, oldUnlock)
        if newUnlock then
            GuiController.HintFirstFloorReached()
        end
    end)
end

return HintClientController