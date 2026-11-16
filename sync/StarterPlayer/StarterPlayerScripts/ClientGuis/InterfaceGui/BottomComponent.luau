local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)
local ContainerComponent = require(script.ContainerComponent)
local CurrencyComponent = require(script.CurrencyComponent)

return function(
    gui: InterfaceGuiService.InterfaceGui,
    props: InterfaceGuiService.InterfaceProps
)
    ContainerComponent(gui, props)
    CurrencyComponent(gui, props)
end
