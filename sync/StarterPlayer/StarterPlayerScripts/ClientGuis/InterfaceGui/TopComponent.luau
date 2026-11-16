local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)
local ButtonsComponent = require(script.ButtonsComponent)
local ContainerComponent = require(script.ContainerComponent)

return function(
    gui: InterfaceGuiService.InterfaceGui,
    props: InterfaceGuiService.InterfaceProps
)
    ButtonsComponent(gui, props)
    ContainerComponent(gui, props)
end
