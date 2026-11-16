local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)
local ContainerComponent = require(script.ContainerComponent)

return function(
    gui: InterfaceGuiService.InterfaceGui,
    props: InterfaceGuiService.InterfaceProps
)
    ContainerComponent(gui, props)
end
