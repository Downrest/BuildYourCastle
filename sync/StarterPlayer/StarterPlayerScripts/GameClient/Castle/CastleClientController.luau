local StarterPlayer = game:GetService("StarterPlayer")
local CastleClientController = {}

local ClientPurchaseController = require(StarterPlayer.StarterPlayerScripts.GameClient.Castle.CastleClientController.ClientPurchaseController)
local GuiController = require(script.GuiController)
local ReplicationController = require(script.ReplicationController)

function CastleClientController.Init()
    ClientPurchaseController.Init()
    ReplicationController.Init()
    GuiController.Mount()
end

return CastleClientController