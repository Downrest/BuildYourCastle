local LocalPlayerUtil = require(game:GetService("StarterPlayer").StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local BottomController = require(script.BottomController)
local LeftController = require(script.LeftController)
local TopController = require(script.TopController)

local InterfaceClientController = {}

local interfaceGui = LocalPlayerUtil.playerGui.Interface

function InterfaceClientController.Init()
    interfaceGui.Enabled = true
    
    TopController.Init()
    LeftController.Init()
    BottomController.Init()
end

function InterfaceClientController.Toggle(isFocused: boolean, isAnimated: boolean?)
    TopController.Toggle(isFocused, isAnimated)
    LeftController.Toggle(isFocused, isAnimated)
    BottomController.Toggle(isFocused, isAnimated)
end

return InterfaceClientController