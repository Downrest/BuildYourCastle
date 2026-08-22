local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)

local TutorialClientService = {}

TutorialClientService.HasTutorialEnded = Signal.new()

return TutorialClientService
