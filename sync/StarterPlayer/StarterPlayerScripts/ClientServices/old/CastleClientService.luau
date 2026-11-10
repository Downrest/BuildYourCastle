local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)

local CastleClientService = {}

CastleClientService.IsFirstFloorUnlocked = Vide.source(true)

function CastleClientService.Init()
    -- DataClientService.PlayerState.castle.floorUnlocked.floor1.Observed(function(new)
    --     CastleClientService.IsFirstFloorUnlocked(new)
    -- end)
end

return CastleClientService
