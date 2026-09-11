local ServerScriptService = game:GetService("ServerScriptService")

local CommandsServerService = require(ServerScriptService.ServerServices.CommandsServerService)

local CommandsServerController = {}

function CommandsServerController.Init()
    CommandsServerService.Init()
end

return CommandsServerController
