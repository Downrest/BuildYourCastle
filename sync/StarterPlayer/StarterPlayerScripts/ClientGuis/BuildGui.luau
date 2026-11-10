local StarterPlayer = game:GetService("StarterPlayer")

local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local MenuComponent = require(script.MenuComponent)
local ModeComponent = require(script.ModeComponent)

return function(
    props: BuildGuiService.BuildProps
)
    return function()
        local gui = BuildGuiService.BUILD_GUI:Clone()

        MenuComponent(gui, props)
        ModeComponent(gui, props)

        return gui
    end
end
