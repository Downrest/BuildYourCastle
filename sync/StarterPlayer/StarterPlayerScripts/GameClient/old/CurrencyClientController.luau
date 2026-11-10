local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local CurrencyClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.CurrencyClientService)
local GuiController = require(script.GuiController)

local CurrencyClientController = {}

function CurrencyClientController.Init()
    GuiController.Init()

    Vide.effect(function()
        GuiController.SetGold(
            CurrencyClientService.CurrentGold(),
            Vide.untrack(CurrencyClientService.PreviousGold)
        )
    end)
end

return CurrencyClientController
