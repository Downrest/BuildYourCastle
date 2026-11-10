local StarterPlayer = game:GetService("StarterPlayer")

local HintGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.HintGuiService)
local VideUtils = require(StarterPlayer.StarterPlayerScripts.ClientUtils.VideUtils)
local HintComponent = require(script.HintComponent)

return function(props: HintGuiService.HintProps)
    return function()
        local gui = HintGuiService.HINT_GUI:Clone()
     
        HintComponent(gui, props)

        return gui
    end
end
