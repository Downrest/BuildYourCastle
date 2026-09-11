local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local InterfaceClientService = {}

InterfaceClientService.IsFirstFloorReached = Vide.source(false)
InterfaceClientService.IsInterfaceEnabled = Vide.source(false)

function InterfaceClientService.Init()
    DataSharedService.LocalPlayerDataInitialized:Connect(function(data)
        
    end)
end

function InterfaceClientService.ToggleInterface(isEnabled: boolean)
    InterfaceClientService.IsInterfaceEnabled(isEnabled)
end

function InterfaceClientService.SetFirstFloorReached(wasReached: boolean)
    InterfaceClientService.IsFirstFloorReached(wasReached)
end

return InterfaceClientService
