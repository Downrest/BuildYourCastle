local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local InterfaceClientService = {}

InterfaceClientService.IsFirstFloorReached = Vide.source(false)
InterfaceClientService.IsInterfaceEnabled = Vide.source(false)

InterfaceClientService.GameFirstlyIntroduced = Vide.source(true)

function InterfaceClientService.Init()
    DataClientService.PlayerState.gameFirstlyIntroduced.Observed(function(new)
        InterfaceClientService.GameFirstlyIntroduced(new)
    end)
end

return InterfaceClientService
