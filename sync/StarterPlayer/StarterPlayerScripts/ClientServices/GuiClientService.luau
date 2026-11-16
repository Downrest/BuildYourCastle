local StarterPlayer = game:GetService("StarterPlayer")

local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local GuiService = {}

GuiService.PLAYER_GUI = LocalPlayerUtil.playerGui
GuiService.GUI_ROOT = GuiService.PLAYER_GUI.Gui --TODO: ClientAssets/Gui.. change that to GuiAssets

return GuiService
