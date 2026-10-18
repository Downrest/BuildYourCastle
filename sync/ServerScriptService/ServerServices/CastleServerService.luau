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

local function pushPlayerIntoVacantCastle(player: Player, data: DataServerService.PlayerData): CastleCache<Player, CastleData>
    local vacantCastleCache = getVacantCastleCache(); do
        assert(vacantCastleCache, `No more vacant castles for {player}?`)
    end
    assert(data, `Attempted to push {player} into vacant castle without player data!`)

    vacantCastleCache.owner = player
    vacantCastleCache.castleData = data.castle

    playerToCastleCache[player] = vacantCastleCache

    return vacantCastleCache:: CastleCache<Player, CastleData>
end

-- local function updatePlayerCastleCache(player: Player, data: DataServerService.PlayerData): (CastleCache<Player, CastleData>, CastleCache<Player, CastleData>)
--     local playerCastleCache = playerToCastleCache[player]; do
--         assert(playerCastleCache, `No castle cache for {player}?`)
--     end

-- 	local previousCastleCache: CastleCache = TableUtil.DeepCopy(
-- 		playerCastleCache
-- 	)
-- 	local newCastleCache: CastleCache = TableUtil.DeepCopy(
-- 		playerCastleCache
-- 	)

--     -- avoid redundant writes
--     if playerCastleCache.castleData ~= data.castle then
--         playerCastleCache.castleData = data.castle
--         newCastleCache = playerCastleCache
--     end

--     return 
--         newCastleCache:: CastleCache<Player, CastleData>,
--         previousCastleCache:: CastleCache<Player, CastleData>
-- end

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
        DataServerService.PlayerDataObserved:Connect(function(player, data)
            if playerToCastleCache[player] then
                local playerCastleCache = playerToCastleCache[player]:: CastleCache<Player, CastleData>; do
                    assert(playerCastleCache, `No castle cache for {player}?`)
                end

                local previousCastleCache = TableUtil.DeepCopy(playerCastleCache)
                local newCastleCache: CastleCache<Player, CastleData>
            
                -- avoid redundant writes
                if playerCastleCache.castleData ~= data.castle then
                    playerCastleCache.castleData = data.castle
                    newCastleCache = playerCastleCache

                    CastleServerService.PlayerCastleChanged:Fire(
                        player, 
                        newCastleCache.castleID, 
                        newCastleCache.castleData.structureData,
                        previousCastleCache.castleData.structureData
                    )
                end
            else
                local castleCache = pushPlayerIntoVacantCastle(player, data)
            
                CastleServerService.PlayerCastleInitialized:Fire(
                    player, 
                    castleCache.castleID, 
                    castleCache.castleData.structureData
                )
            end
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

function CastleServerService.IsStructureUnlockable(
    player: Player, 
    playerData: DataServerService.PlayerData, 
    structureID: string
): boolean
    local structureData = playerData.castle.structureData[structureID]; do
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

function CastleServerService.UnlockStructure(
    player: Player, 
    playerData: DataServerService.PlayerData, 
    structureID: string
): boolean
    local unlockedStructureData = playerData.castle.structureData[structureID]; do
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
            warn(`LOOPING THRU {structureID}`)
            local purchaseableStructureData = playerData.castle.structureData[structureID]
            if not purchaseableStructures then
                continue
            end

            warn(purchaseableStructureData)
            purchaseableStructureData[1] = true
        end
    end

    for floorName in CastleSharedService.FLOOR_NAMES:: {[string]: string} do
        local floorStructures = CastleSharedService.FLOOR_END_STRUCTURES[floorName]; do
            assert(floorStructures, `Failed to acknowledge any structures from {floorName}`)
        end
        local endStructure = floorStructures["end"]
        local isFloorUnlocked = playerData.castle.floorUnlocked[floorName]

        if 
            endStructure == structureID
            and not isFloorUnlocked
        then
            warn(`UNLOCKED {floorName}`)
            playerData.castle.floorUnlocked[floorName] = true
        end
    end

    return true
end

return CastleServerService