local StarterPlayer = game:GetService("StarterPlayer")

local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local GuiService = {}

GuiService.GUI = LocalPlayerUtil.playerGui.Gui

return GuiService
