local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local DataServerController = require(ServerScriptService.GameServer.Data.DataServerController)

RunService.Heartbeat:Once(function()
    DataServerController.Init()
end)