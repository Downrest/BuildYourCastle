local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CurrencySharedService = require(ReplicatedStorage.SharedServices.CurrencySharedService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CurrencyServerController = {}

local function replicateGoldCurrency(
    player: Player,
    newData: DataServerService.PlayerData,
    oldData: DataServerService.PlayerData?
)
    if oldData and (newData.currency.gold == oldData.currency.gold) then
        return
    end

    CurrencySharedService.GoldChanged.server:FireClient(
        player, 
        newData.currency.gold,
        oldData and oldData.currency.gold
    )
end

function CurrencyServerController.Init()
    DataServerService.DataChanged:Connect(function(
        player,
        newData,
        oldData
    )
        replicateGoldCurrency(player, newData, oldData)
    end)

    --TODO: test
    do
        while true do
            for _, player in Players:GetPlayers() do
                DataServerService.SetGold(player, DataServerService.GetPlayerData(player).currency.gold - 100)
            end
            task.wait(1)
        end
    end
end

return CurrencyServerController
