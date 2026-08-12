local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CastleServerService = {}

export type CastleData = DataServerService.CastleData
export type CastleCache = {
    owner: Player?;
    castleData: CastleData?;
    castleID: number;
}

export type StructureData = {
    cost: {
        gold: number;   
    };
}

CastleServerService.CastleCache = {}:: {CastleCache}

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

    local castleCache = CastleServerService.CastleCache[currentIndex]; do
        while castleCache.owner ~= player do
            currentIndex += 1
            castleCache = CastleServerService.CastleCache[currentIndex]
        end
    end

    return castleCache
end

local function getVacantCastleCache(): CastleCache?
    local currentIndex = 1

    local vacantCastle = CastleServerService.CastleCache[currentIndex]; do
        while vacantCastle["owner"] do
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

    return castleData:: DataServerService.CastleData
end

local function setPlayerCastleData(player: Player, castleData: CastleData)
    local playerCastleCache = getPlayerCastleCache(player)
    if not playerCastleCache then
        return
    end

    playerCastleCache.castleData = castleData
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
                }
            )
        end
    end
end

function CastleServerService.GetStructureData(structureID: string): StructureData
    return STRUCTURE_ID_DATA[structureID]
end

function CastleServerService.IsPlayerStructurePurchased(player: Player, structureID: string): boolean
    local playerCastleData = CastleServerService.GetPlayerCastleCache(player)
    assert(playerCastleData and playerCastleData.castleData, "Attempted to check structure purchased status with nil player castle data!")

    local structureData = playerCastleData.castleData.structureData[structureID]
    local isUnlocked = structureData[2]

    return isUnlocked
end

function CastleServerService.PurchasePlayerStructure(player: Player, structureID: string): boolean
    return DataServerService.SetPlayerDataAsync(player, function(data)
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

        warn(`PURCHASED! NEW DATA IS... `, data)

        return true
    end)
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

return CastleServerService
