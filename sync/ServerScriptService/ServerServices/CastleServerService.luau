local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local TableUtil = require(ReplicatedStorage.SharedUtils.TableUtil)

local CastleServerService = {}

export type StructureData = DataServerService.CastleStructureData
export type CastleData = DataServerService.CastleData

export type CastleCache<
    owner = Player?,
    castleData = CastleData?
> = {
    owner: owner;
    castleData: castleData;
    castleID: number;
}

CastleServerService.PlayerCastleInitialized = Signal.new<<(
    player: Player, 
    castleID: number,
    initStructureData: StructureData
) -> ()>>()
CastleServerService.PlayerCastleChanged = Signal.new<<(
    player: Player, 
    castleID: number,
    newStructureData: StructureData,
    previousStructureData: StructureData
) -> ()>>()
CastleServerService.PlayerCastleReleased = Signal.new<<(
    player: Player,
    castleID: number
) -> ()>>()

CastleServerService.CastleCacheList = {}:: {CastleCache}

local playerToCastleCache = {}:: {[Player]: CastleCache}

local MAX_CASTLES = 4

local function getVacantCastleCache(): CastleCache?
    local currentIndex = 1
    local castleCache = CastleServerService.CastleCacheList[currentIndex]; do
        while castleCache and castleCache.owner ~= nil do
            currentIndex += 1
            castleCache = CastleServerService.CastleCacheList[currentIndex]
        end
    end

    return castleCache
end

local function pushPlayerIntoVacantCastle(player: Player): CastleCache<Player, CastleData>
    local vacantCastleCache = getVacantCastleCache(); do
        assert(vacantCastleCache, `No more vacant castles for {player}?`)
    end
    local playerData = DataServerService.GetPlayerDataAsync(player); do
        assert(playerData, `No player data for {player}?`)
    end

    vacantCastleCache.owner = player
    vacantCastleCache.castleData = playerData.castle

    playerToCastleCache[player] = vacantCastleCache

    return vacantCastleCache:: CastleCache<Player, CastleData>
end

local function updatePlayerCastleCache(player: Player, data: DataServerService.PlayerData): (CastleCache<Player, CastleData>, CastleCache<Player, CastleData>)
    local playerCastleCache = playerToCastleCache[player]; do
        assert(playerCastleCache, `No castle cache for {player}?`)
    end

    local previousCastleCache, newCastleCache

    -- avoid redundant writes
    if playerCastleCache.castleData ~= data.castle then
        previousCastleCache = TableUtil.DeepCopy(
            playerCastleCache
        )

        playerCastleCache.castleData = data.castle
        newCastleCache = playerCastleCache
    end

    return 
        newCastleCache:: CastleCache<Player, CastleData>,
        previousCastleCache:: CastleCache<Player, CastleData>
end

local function cleanupPlayerCastle(player: Player): number
    local playerCastleCache = playerToCastleCache[player]; do
        assert(playerCastleCache, `No existing castle cache for {player} pre-cleanup?`)
    end

    playerCastleCache.owner = nil
    playerCastleCache.castleData = nil

    playerToCastleCache[player] = nil

    return playerCastleCache.castleID
end

function CastleServerService.Init()
    -- initializing castle cache
    do
        for castleID = 1, MAX_CASTLES do
            table.insert(
                CastleServerService.CastleCacheList,
                {
                    owner = nil;
                    castleData = nil;
                    castleID = castleID;
                }
            )
        end
    end

    -- castle cache lifecycles + data updates
    do
        DataServerService.PlayerDataLoaded:Connect(function(player)
            local castleCache = pushPlayerIntoVacantCastle(player)
            
            CastleServerService.PlayerCastleInitialized:Fire(
                player, 
                castleCache.castleID, 
                castleCache.castleData.structureData
            )
        end)

        DataServerService.PlayerDataChanged:Connect(function(player, data)
            -- player castle not yet existing? probably hasnt initialized yet (for CastleServerService)
            if not playerToCastleCache[player] then
                return
            end

            local newCastleCache, previousCastleCache = updatePlayerCastleCache(player, data)

            CastleServerService.PlayerCastleChanged:Fire(
                player, 
                newCastleCache.castleID, 
                newCastleCache.castleData.structureData,
                previousCastleCache.castleData.structureData
            )
        end)

        Players.PlayerRemoving:Connect(function(player)
            local emptyCastleID = cleanupPlayerCastle(player)

            CastleServerService.PlayerCastleReleased:Fire(
                player, 
                emptyCastleID
            )
        end)
    end
end

function CastleServerService.GetCastleCacheList(): {CastleCache}
    return CastleServerService.CastleCacheList
end

function CastleServerService.GetStructureConfig(structureID: string): CastleSharedService.StructureConfig?
    return (CastleSharedService.STRUCTURE_CONFIG_DATA:: {[string]: CastleSharedService.StructureConfig})[structureID]
end

function CastleServerService.IsStructureUnlockable(data: DataServerService.PlayerData, structureID: string): boolean
    local structureData = data.castle.structureData[structureID]; do
        assert(structureData, `Structure ID {structureID} not found?`)
    end

    local isPurchaseable = structureData[1]
    local isUnlocked = structureData[2]

    --[[
        must be 
            purchaseable (in terms of progression order)
            not yet unlocked
    ]]
    return 
        isPurchaseable 
        and not isUnlocked
end

function CastleServerService.UnlockStructure(data: DataServerService.PlayerData, structureID: string): boolean
    local unlockedStructureData = data.castle.structureData[structureID]; do
        assert(unlockedStructureData, `Structure ID {structureID} not found in structure data?`)
    end

    local structureConfig = CastleServerService.GetStructureConfig(structureID); do
        assert(structureConfig, `Structure ID {structureID} without valid config?`)
    end
    local purchaseableStructures = structureConfig.purchaseable

    -- mutate structure data
    do
        -- set unlocked to unlocked structure
        unlockedStructureData[2] = true

        -- set purchaseable to new progression structures
        for _, structureID in purchaseableStructures do
            local purchaseableStructureData = data.castle.structureData[structureID]; do
                if not purchaseableStructures then
                    continue
                end
            end

            purchaseableStructureData[1] = true
        end
    end

    return true
end

return CastleServerService