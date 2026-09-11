local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)
local GuiController = require(script.GuiController)

local CurrencyClientController = {}

function CurrencyClientController.Init()
    GuiController.Init()

    DataSharedService.LocalPlayerDataInitialized:Connect(function(dataReplicated)
        local playerCurrency = dataReplicated.attributes.currency

        -- gold changes
        playerCurrency.gold.Changed:Connect(function(
            newGold,
            oldGold
        )
            GuiController.SetGold(newGold, oldGold)
        end)
    end)
end

return CurrencyClientController
