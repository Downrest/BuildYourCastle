local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local CurrencyClientService = {}

CurrencyClientService.CurrentGold = Vide.source(0)
CurrencyClientService.PreviousGold = Vide.source(0)

function CurrencyClientService.Init()
    DataClientService.PlayerState.currency.gold.Observed(function(new, old)
        CurrencyClientService.PreviousGold(old or new)
        CurrencyClientService.CurrentGold(new)
    end)
end

return CurrencyClientService
