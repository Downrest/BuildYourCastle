local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ReplicatedFirst interacts w/ LoadingClientService, so u have to do this first
ReplicatedStorage:WaitForChild("SharedPackages")
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local LoadingClientService = {}

LoadingClientService.IsLoaded = Vide.source(false)

return LoadingClientService
