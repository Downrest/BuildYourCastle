local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local TypedAttribute = require(ReplicatedStorage.SharedPackages.TypedAttribute)
local TypedEvent = require(ReplicatedStorage.SharedPackages.TypedEvent)

local DataSharedService = {}

export type ReplicatedData = {
    config: Configuration;
    attributes: {
        currency: {
            gold: TypedAttribute.TypedAttribute<number>;
        }
    }
}

local ATTRIBUTE_TAGS = {
    Gold = "Gold";
}

local playerCurrencies = {}:: {[Player]: ReplicatedData}

DataSharedService.ClientDataReady = 
    TypedEvent.newReliable("ClientDataReady"):: TypedEvent.ClientToServer<any>

DataSharedService.PlayerDataInitialized = Signal.new<<(player: Player, replicatedData: ReplicatedData) -> ()>>()

function registerPlayer(player: Player): ReplicatedData
    assert(not playerCurrencies[player], `Attempted to register player with existing replicated currency state?`)

    local config = Instance.new("Configuration"); do
        config.Name = player.Name
    end
    local goldAttribute = TypedAttribute.new(ATTRIBUTE_TAGS.Gold, 0)

    local replicatedData = {
        config = config;
        attributes = {
            currency = {
                gold = goldAttribute;
            };
        };
    }; do
        playerCurrencies[player] = replicatedData
        DataSharedService.PlayerDataInitialized:Fire(player, replicatedData)
    end

    return replicatedData
end

function DataSharedService.Init()
    for _, player in Players:GetPlayers() do
        registerPlayer(player)
    end
    Players.PlayerAdded:Connect(function(player)
        registerPlayer(player)
    end)
end

return DataSharedService

