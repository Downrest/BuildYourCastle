local StarterPlayer = game:GetService("StarterPlayer")

local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local TweenComponent = require(script.TweenComponent)
local SelectionComponent = require(script.SelectionComponent)

return function(
    gui: BuildGuiService.BuildGui,
    props: BuildGuiService.BuildProps
)
    TweenComponent(gui, props)
    SelectionComponent(gui, props)
end
