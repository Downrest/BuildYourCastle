local BuildClientController = {}

local GuiController = require(script.GuiController)

function BuildClientController.Init()
    GuiController.Mount()
end

return BuildClientController