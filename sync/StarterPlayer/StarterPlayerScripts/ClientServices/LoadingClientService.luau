local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage:WaitForChild("SharedPackages").Vide)

local LoadingClientService = {}

LoadingClientService.IsLoaded = Vide.source(false)

return LoadingClientService
