local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)
local TransactionServerService = require(ServerScriptService.ServerServices.TransactionServerService)
local TutorialSharedService = require(ReplicatedStorage.SharedServices.TutorialSharedService)

local TutorialServerService = {}

function TutorialServerService.Init()
    TutorialSharedService.TutorialFinishedUpdate.server.OnServerEvent:Connect(function(
        player,
        isFinished
    )
        TransactionServerService.FinishTutorial(player)
    end)
end

function TutorialServerService.IsTutorialFinished(player: Player): boolean
    local data = DataServerService.GetPlayerDataAsync(player)

    return data.castle.tutorialFinished
end

return TutorialServerService