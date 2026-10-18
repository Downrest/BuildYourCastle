local StarterPlayer = game:GetService("StarterPlayer")

local DataClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
local GuiController = require(script.GuiController)

local CurrencyClientController = {}

function CurrencyClientController.Init()
    GuiController.Init()

    DataClientService.PlayerState.currency.gold.Observed(function(newGold, oldGold)
        GuiController.SetGold(newGold, oldGold)
    end)
end

return CurrencyClientController
