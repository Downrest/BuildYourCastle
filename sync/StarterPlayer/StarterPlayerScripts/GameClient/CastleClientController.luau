local StarterPlayer = game:GetService("StarterPlayer")
local CastleClientController = {}

local ClientPurchaseController = require(script.ClientPurchaseController)
local ReplicationController = require(script.ReplicationController)

function CastleClientController.Init()
    ClientPurchaseController.Init()
    ReplicationController.Init()
end

return CastleClientController