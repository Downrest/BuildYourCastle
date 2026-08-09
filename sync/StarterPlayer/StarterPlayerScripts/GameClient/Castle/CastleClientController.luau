local CastleClientController = {}

local GuiController = require(script.GuiController)
local ReplicationController = require(script.ReplicationController)

function CastleClientController.Init()
    ReplicationController.Init()
    GuiController.Mount()
end

return CastleClientController