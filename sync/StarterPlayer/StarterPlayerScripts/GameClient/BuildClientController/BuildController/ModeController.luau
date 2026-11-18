local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local StateMachineUtil = require(ReplicatedStorage.SharedUtils.StateMachineUtil)
local SelectController = require(script.SelectController)
local MoveController = require(script.MoveController)
local RotateController = require(script.RotateController)
local DeleteController = require(script.DeleteController)

local ModeController = {}

local MODE_STATES = {
    [BuildGuiService.BUTTON_SELECTIONS.Select] = BuildClientService.HANDLE_STATES.Select;
    [BuildGuiService.BUTTON_SELECTIONS.Move] = BuildClientService.HANDLE_STATES.Move;
    [BuildGuiService.BUTTON_SELECTIONS.Rotate] = BuildClientService.HANDLE_STATES.Rotate;
    [BuildGuiService.BUTTON_SELECTIONS.Delete] = BuildClientService.HANDLE_STATES.Delete;
}

local stateMachine = StateMachineUtil.stateMachine({
    [BuildClientService.HANDLE_STATES.Select] = SelectController;
    [BuildClientService.HANDLE_STATES.Move] = MoveController;
    [BuildClientService.HANDLE_STATES.Rotate] = RotateController;
    [BuildClientService.HANDLE_STATES.Delete] = DeleteController;
})

function ModeController.Init()
    Vide.effect(function()
        local state = MODE_STATES[BuildGuiService.CurrentMode()]
        if not state then
            return
        end

        if BuildGuiService.IsVisible() then
            if BuildClientService.CurrentBuildData() == BuildClientService.NIL_BUILD_DATA then
                return
            end
    
            stateMachine:SetState(state)
        else
            stateMachine:SetState(nil)
        end
    end)
end

return ModeController
