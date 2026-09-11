local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local DataClientController = {}

function DataClientController.Init()
    DataSharedService.LocalPlayerDataInitialized:Connect(function()
        warn(`CLIENT IS READY`)
        DataSharedService.ClientDataReady.client:FireServer()
    end)
end

return DataClientController
