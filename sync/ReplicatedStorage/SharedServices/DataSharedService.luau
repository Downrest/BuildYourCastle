local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local TypedAttribute = require(ReplicatedStorage.SharedPackages.TypedAttribute)
local TypedEvent = require(ReplicatedStorage.SharedPackages.TypedEvent)

local DataSharedService = {}

export type ReplicatedData = {
    config: Configuration;
    attributes: {
        currency: {
            gold: TypedAttribute.TypedAttribute<number>;
		};
        castle: {
            tutorialFinished: TypedAttribute.TypedAttribute<boolean>;
            floorUnlocked: {
                floor1: TypedAttribute.TypedAttribute<boolean>;
                floor2: TypedAttribute.TypedAttribute<boolean>;
                floor3: TypedAttribute.TypedAttribute<boolean>;
                floor4: TypedAttribute.TypedAttribute<boolean>;
            };
        };
    }
}

local ATTRIBUTE_TAGS = {
    -- currency
    Gold = "Gold";

    -- floor unlocked
    Floor1 = "Floor1";
    Floor2 = "Floor2";
    Floor3 = "Floor3";
    Floor4 = "Floor4";

    -- finished tutorial
    TutorialFinished = "TutorialFinished";
}

local playerDataList = {}:: {[Player]: ReplicatedData}

DataSharedService.ClientDataReady = 
    TypedEvent.newReliable("ClientDataReady")

DataSharedService.LocalPlayerDataInitialized = Signal.new<<(replicatedData: ReplicatedData) -> ()>>()
DataSharedService.PlayerDataInitialized = Signal.new<<(player: Player, replicatedData: ReplicatedData) -> ()>>()

function registerPlayer(player: Player): ReplicatedData
    assert(not playerDataList[player], `Attempted to register player with existing replicated currency state?`)

    local config: Configuration; do
        if RunService:IsClient() then
            config = script:WaitForChild(player.Name):: Configuration
        else
            config = Instance.new("Configuration")
            config.Name = player.Name
            config.Parent = script
        end
    end

    -- currency
    local goldAttribute = TypedAttribute.new(ATTRIBUTE_TAGS.Gold, 0, config)

    -- floor unlocked
    local floor1UnlockedAttribute = TypedAttribute.new(ATTRIBUTE_TAGS.Floor1, false, config)
    local floor2UnlockedAttribute = TypedAttribute.new(ATTRIBUTE_TAGS.Floor2, false, config)
    local floor3UnlockedAttribute = TypedAttribute.new(ATTRIBUTE_TAGS.Floor3, false, config)
    local floor4UnlockedAttribute = TypedAttribute.new(ATTRIBUTE_TAGS.Floor4, false, config)

    -- finished tutorial
    local tutorialFinishedAttribute = TypedAttribute.new(ATTRIBUTE_TAGS.TutorialFinished, false, config)

    local replicatedData = {
        config = config;
        attributes = {
            currency = {
                gold = goldAttribute;
            };
            castle = {
                tutorialFinished = tutorialFinishedAttribute;
                floorUnlocked = {
                    floor1 = floor1UnlockedAttribute;
                    floor2 = floor2UnlockedAttribute;
                    floor3 = floor3UnlockedAttribute;
                    floor4 = floor4UnlockedAttribute;
                };
            };
        };
    }

    playerDataList[player] = replicatedData
    DataSharedService.PlayerDataInitialized:Fire(player, replicatedData)
    warn(`INITIALIZED!!! {player}`)

    if 
        RunService:IsClient()
        and player == Players.LocalPlayer
    then
        DataSharedService.LocalPlayerDataInitialized:Fire(replicatedData)
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

