local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)

local ReplicationController = {}

function ReplicationController.Init()
    CastleSharedService.ClientReplicationReady.client:FireServer()
end

return ReplicationController
