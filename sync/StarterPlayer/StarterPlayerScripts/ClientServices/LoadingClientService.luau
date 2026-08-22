local ReplicatedStorage = game:GetService("ReplicatedStorage")

ReplicatedStorage:WaitForChild("SharedPackages")
local Signal = require(ReplicatedStorage.SharedPackages.Signal)

local LoadingClientService = {}

LoadingClientService.HasLoaded = Signal.new()

return LoadingClientService
