local StarterPlayer = game:GetService("StarterPlayer")

local TutorialClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.TutorialClientService)
local InterfaceClientController = require(StarterPlayer.StarterPlayerScripts.GameClient.Interface.InterfaceClientController)

InterfaceClientController.Init()

TutorialClientService.HasTutorialEnded:Once(function()
    InterfaceClientController.Toggle(true, true)
end)

