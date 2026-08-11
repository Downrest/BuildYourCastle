local ServerScriptService = game:GetService("ServerScriptService")

local CastleServerController = require(ServerScriptService.GameServer.Castle.CastleServerController)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

DataServerService.OnServiceInitialized(function()
    CastleServerController.Init()
end)
