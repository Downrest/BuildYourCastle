local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local InterfaceConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.InterfaceConfig)
local TransitionConfig = require(script.TransitionConfig)

local InterfaceClientService = {}

InterfaceClientService.CurrentGui = Vide.source(
    InterfaceConfig.GUIS.Interface
)

local function transition(transitionGui: string, isEntering: boolean)
    local currentGui = InterfaceClientService.CurrentGui()
    local guiTransitions = TransitionConfig.TRANSITIONS[currentGui]
    local nextGui: string; do
        local transitions = (isEntering and guiTransitions.enter or guiTransitions.exit):: {string}
        local nextGuiKey = table.find(transitions, transitionGui)
        assert(nextGuiKey, `{transitionGui} is not valid {isEntering and `enter` or `exit`} transition for {currentGui}`)

        nextGui = transitions[nextGuiKey]
    end

    InterfaceClientService.CurrentGui(nextGui)
end

function InterfaceClientService.Exit(exitGui: string)
    transition(exitGui, false)
end

function InterfaceClientService.Enter(enterGui: string)
    transition(enterGui, true)
end

return InterfaceClientService
