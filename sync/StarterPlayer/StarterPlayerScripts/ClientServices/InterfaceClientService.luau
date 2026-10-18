local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local InterfaceClientService = {}

InterfaceClientService.IsFirstFloorReached = Vide.source(false)
InterfaceClientService.IsInterfaceEnabled = Vide.source(false)

InterfaceClientService.GameFirstlyIntroduced = Vide.source(true)

return InterfaceClientService
