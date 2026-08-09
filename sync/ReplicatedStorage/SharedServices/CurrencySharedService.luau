local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TypedEvent = require(ReplicatedStorage.SharedPackages.TypedEvent)

local CurrencySharedService = {}

CurrencySharedService.GoldChanged = 
    TypedEvent.newReliable("GoldChanged"):: TypedEvent.ServerToClient<(newGold: number, oldGold: number?) -> ()>

return CurrencySharedService
