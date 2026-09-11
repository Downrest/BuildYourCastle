local StarterPlayer = game:GetService("StarterPlayer")
local TutorialClientController = {}

local LoadingClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.LoadingClientService)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local DialogueConfig = require(script.TutorialConfigs.DialogueConfig)
local DialogueGuiController = require(script.DialogueGuiController)

-- function TutorialClientController.Init()
--     DialogueConfig.Init(LocalPlayerUtil.player)
--     DialogueGuiController.Init()

--     LoadingClientService.HasLoaded:Once(function()
--         TutorialClientController.Start()
--     end)
-- end

function TutorialClientController.Start()
    DialogueGuiController.StartDialogue()
end

return TutorialClientController