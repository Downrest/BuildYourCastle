local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local DataClientController = {}

function DataClientController.Init()
    DataSharedService.PlayerDataInitialized:Connect(function(
        player
    )
        if player ~= LocalPlayerUtil.player then
            return
        end

        warn(`CLIENT IS READY`)
        DataSharedService.ClientDataReady.client:FireServer()
    end)

    task.wait(); do
        DataSharedService.Init()
    end
end

return DataClientController
