local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TypedRemote = require(ReplicatedStorage.SharedPackages.TypedRemote)

local TutorialSharedService = {}

TutorialSharedService.TutorialFinishedUpdate = 
    TypedRemote.newReliableEvent("TutorialFinishedUpdate")
    :: TypedRemote.ToServerEvent<(isFinished: boolean) -> ()>

return TutorialSharedService