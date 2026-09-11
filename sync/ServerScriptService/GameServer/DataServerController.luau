local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local DataServerController = {}

function DataServerController.Init()
    DataSharedService.Init()
    DataServerService.Init()
end

return DataServerController
