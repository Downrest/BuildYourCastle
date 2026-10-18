local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local DataServerController = {}

function DataServerController.Init()
    DataServerService.Init()
end

return DataServerController
