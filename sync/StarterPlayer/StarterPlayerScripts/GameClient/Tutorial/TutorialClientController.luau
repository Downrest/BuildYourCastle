local StarterPlayer = game:GetService("StarterPlayer")
local TutorialClientController = {}

local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local DialogueConfig = require(StarterPlayer.StarterPlayerScripts.GameClient.Tutorial.TutorialConfigs.DialogueConfig)
local DialogueGuiController = require(script.DialogueGuiController)

function TutorialClientController.Init()
    DialogueConfig.Init(LocalPlayerUtil.player)
    
    DialogueGuiController.Init()
end

function TutorialClientController.Start()
    DialogueGuiController.StartDialogue()
end

return TutorialClientController