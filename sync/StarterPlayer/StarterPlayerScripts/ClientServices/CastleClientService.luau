local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local CastleClientService = {}

CastleClientService.CastleID = Vide.source(0)

function CastleClientService.Init()
    DataClientService.PlayerState.castle.id.Observed(function(new)
        CastleClientService.CastleID(new)
    end)
end

return CastleClientService
