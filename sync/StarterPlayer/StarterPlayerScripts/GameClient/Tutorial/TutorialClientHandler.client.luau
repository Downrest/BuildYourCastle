local StarterPlayer = game:GetService("StarterPlayer")

local LoadingClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.LoadingClientService)
local TutorialClientController = require(StarterPlayer.StarterPlayerScripts.GameClient.Tutorial.TutorialClientController)

TutorialClientController.Init()

LoadingClientService.HasLoaded:Once(function()
    TutorialClientController.Start()
end)
