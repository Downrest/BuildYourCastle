local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local CurrencyClientService = {}

CurrencyClientService.Gold = Vide.source(0)

function CurrencyClientService.Init()
    DataClientService.PlayerState.currency.gold.Observed(function(new)
        CurrencyClientService.Gold(new)
    end)
end

return CurrencyClientService
