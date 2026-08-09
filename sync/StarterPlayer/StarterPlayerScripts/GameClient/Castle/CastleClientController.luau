local CastleClientController = {}

local GuiController = require(script.GuiController)

function CastleClientController.Init()
    GuiController.Mount()
end

return CastleClientController