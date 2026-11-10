local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.InterfaceGuiService)
local TopComponent = require(script.TopComponent)
local BottomComponent = require(script.BottomComponent)
local LeftComponent = require(script.LeftComponent)

return function(props: InterfaceGuiService.InterfaceProps)
    return function()
        local interface = InterfaceGuiService.INTERFACE_GUI:Clone()

        TopComponent(interface, props)
        BottomComponent(interface, props)
        LeftComponent(interface, props)

        return interface
    end
end
