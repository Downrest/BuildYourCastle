local ServerScriptService = game:GetService("ServerScriptService")

local CastleServerController = require(ServerScriptService.GameServer.Castle.CastleServerController)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

DataServerService.DataServiceInitialized:Once(function()
    CastleServerController.Init()
end)
