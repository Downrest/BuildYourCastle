local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local DataClientController = {}

function DataClientController.Init()
    warn(`CLIENT IS READY`)
    DataSharedService.ClientDataReady.client:FireServer()
end

return DataClientController
