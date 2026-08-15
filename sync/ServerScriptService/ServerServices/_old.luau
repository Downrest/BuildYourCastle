local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local CleanupUtil = require(ReplicatedStorage.SharedUtils.CleanupUtil)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CastleServerService = {}

export type CastleData = DataServerService.CastleData
export type CastleCache = {
    owner: Player?;
    castleData: CastleData?;
    castleID: number;
    castleBin: {CleanupUtil.Trash};
}

export type StructureData = {
    cost: {
        gold: number;   
    };
}

CastleServerService.CastleCache = {}:: {CastleCache}

CastleServerService.PlayerCastleLeft = Signal.new<<(playerLeaving: Player, playerCastleCache: CastleCache) -> ()>>()

local MAX_CASTLES = 4
local STRUCTURE_ID_DATA = {
    [CastleSharedService.STRUCTURE_NAMES.Pathway1] = {
        cost = {
            gold = 30;   
        };
    }
}

local function getPlayerCastleCache(player: Player): CastleCache?
    local currentIndex = 1

    local castleCache: CastleCache? = CastleServerService.CastleCache[currentIndex]; do
        while castleCache and (castleCache.owner ~= player) do
            currentIndex += 1
            castleCache = CastleServerService.CastleCache[currentIndex]
        end
    end

    return castleCache
end

local function getVacantCastleCache(): CastleCache?
    local currentIndex = 1

    local vacantCastle: CastleCache? = CastleServerService.CastleCache[currentIndex]; do
        while vacantCastle and vacantCastle["owner"] do
            currentIndex += 1
            vacantCastle = CastleServerService.CastleCache[currentIndex]
        end
    end

    return vacantCastle
end

local function getPlayerCastleData(player: Player): CastleData
    local playerCastleCache = getPlayerCastleCache(player)
    local castleData = playerCastleCache and playerCastleCache.castleData; do
        if not castleData then
            castleData = DataServerService.GetPlayerDataAsync(player).castle
        end
    end

    return castleData:: CastleData
end

local function setPlayerCastleData(player: Player, castleData: CastleData)
    local playerCastleCache = getPlayerCastleCache(player)
    assert(playerCastleCache, `Attempted to set/update castle data of player with nil castle cache`)

    playerCastleCache.castleData = castleData
end

local function resetCastleCache(castleCache: CastleCache)
    CleanupUtil.Clean(castleCache.castleBin)

    castleCache.castleData = nil
    castleCache.owner = nil
end

function CastleServerService.Init()
    -- initializing castle cache
    do
        for castleID = 1, MAX_CASTLES do
            table.insert(
                CastleServerService.CastleCache,
                {
                    owner = nil;
                    castleData = nil;
                    castleID = castleID;
                    castleBin = {};
                }
            )
        end
    end

    -- clear castle cache when player leaves
    do
        Players.PlayerRemoving:Connect(function(player)
            local playerCastleCache = getPlayerCastleCache(player)
            assert(playerCastleCache, "Player left without ever having castle cache? Must be a bug.")
    
            CastleServerService.PlayerCastleLeft:Fire(player, playerCastleCache)
            resetCastleCache(playerCastleCache)
        end)
    end
end

function CastleServerService.GetStructureData(structureID: string): StructureData
    return STRUCTURE_ID_DATA[structureID]
end

function CastleServerService.GetPlayerCastleCache(player: Player): CastleCache?
    return getPlayerCastleCache(player)
end

function CastleServerService.GetPlayerCastleCacheList(): {CastleCache}
    return CastleServerService.CastleCache
end

function CastleServerService.AddPlayerCastleCache(player: Player): CastleCache
    local vacantCastle = getVacantCastleCache()
    assert(vacantCastle, "Attempted to add player castle when all castles are already occupied?")

    vacantCastle.owner = player
    vacantCastle.castleData = getPlayerCastleData(player)

    return vacantCastle
end

function CastleServerService.IsPlayerStructurePurchased(player: Player, structureID: string): boolean
    local playerCastleData = CastleServerService.GetPlayerCastleCache(player)
    assert(playerCastleData and playerCastleData.castleData, "Attempted to check structure purchased status with nil player castle data!")

    local structureData = playerCastleData.castleData.structureData[structureID]
    local isUnlocked = structureData[2]

    return isUnlocked
end

function CastleServerService.UnlockPlayerStructure(data: DataServerService.PlayerData, structureID: string): boolean
    local structureData = data.castle.structureData[structureID]
    local isPurchaseable = structureData[1]
    local isUnlocked = structureData[2]

    if not isPurchaseable then
        return false
    end
    assert(not isUnlocked, "Attempted to purchase a structure that's already unlocked? Must be a bug.")

    -- update structure data
    do
        local newIsUnlocked = true

        data.castle.structureData[structureID] = {
            isPurchaseable, newIsUnlocked
        }
    end

    -- update internal castle cache
    do
        setPlayerCastleData(player, data.castle)
    end

    return true
end

return CastleServerService
