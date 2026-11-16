local GuiController = require(script.GuiController)
local BuildController = require(script.BuildController)

local BuildClientController = {}

function BuildClientController.Init()
    GuiController.Init()
    BuildController.Init()
end

return BuildClientController
