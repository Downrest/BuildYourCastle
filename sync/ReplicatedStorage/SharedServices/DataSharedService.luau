local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TypedEvent = require(ReplicatedStorage.SharedPackages.TypedEvent)

local DataSharedService = {}

DataSharedService.ClientDataReady = 
    TypedEvent.newReliable("ClientDataReady"):: TypedEvent.ClientToServer<any>

return DataSharedService
