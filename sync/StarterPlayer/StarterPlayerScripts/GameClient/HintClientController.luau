local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)
local GuiController = require(script.GuiController)

local HintClientController = {}

function HintClientController.Init()
    GuiController.Init()

    DataSharedService.LocalPlayerDataInitialized:Connect(function(dataReplicated)
        local playerFloorUnlocked = dataReplicated.attributes.castle.floorUnlocked

        playerFloorUnlocked.floor1.Changed:Connect(function(
            newUnlock,
            oldUnlock
        )
            if newUnlock then
                GuiController.HintFirstFloorReached()
            end
        end)
    end)
end

return HintClientController