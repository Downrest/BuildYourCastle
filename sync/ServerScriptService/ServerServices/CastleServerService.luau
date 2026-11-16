local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CastleConfig = require(ReplicatedStorage.SharedConfigs.CastleConfig.CastleConfig)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local CastleRenderSharedService = require(ReplicatedStorage.SharedServices.CastleServices.CastleRenderSharedService)
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

local function getVacantCastleCache(): (CastleCache?, number?)
    local currentID = 1
    local castleCache = CastleServerService.CastleCacheList[currentID]; do
        while castleCache and castleCache.owner ~= nil do
            currentID += 1
            castleCache = CastleServerService.CastleCacheList[currentID]
        end
    end

    if castleCache then
        return castleCache, currentID
    end
    return nil, nil
end

local function pushPlayerIntoVacantCastle(player: Player): CastleCache<Player, CastleData>
    local vacantCastleCache, vacantID = getVacantCastleCache(); do
        assert(vacantCastleCache and vacantID, `No more vacant castles for {player}?`)
    end
    local data: DataServerService.PlayerData

    -- data mutation
    do
        DataServerService.SetPlayerDataAsync(player, function(data)
            -- local to the player
            data.castle.id = vacantID 

            return true
        end)
        data = DataServerService.GetPlayerDataAsync(player); do
            assert(data, `Failed to get {player}'s data during vacant castle initialization!`)
        end
    end
    
    -- castle caching
    do
        vacantCastleCache.owner = player
        vacantCastleCache.castleID = data.castle.id
        vacantCastleCache.castleData = data.castle

        playerToCastleCache[player] = vacantCastleCache
    end

    return vacantCastleCache:: CastleCache<Player, CastleData>
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
        for castleID = 1, CastleConfig.MAX_CASTLES do
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

    -- castle cache lifecycles
    do
        DataServerService.PlayerDataObserved:Connect(function(player, data)
            local playerCastleCache = playerToCastleCache[player]:: CastleCache<Player, CastleData>

            if playerCastleCache then
                -- PlayerCastleChanged

                if playerCastleCache.castleData == data.castle then
                    return
                end

                local previousCastleData: CastleData = TableUtil.DeepCopy(playerCastleCache.castleData)

                -- mutation
                do
                    playerCastleCache.castleData = data.castle
                end
                
                CastleServerService.PlayerCastleChanged:Fire(
                    player,
                    playerCastleCache.castleID, 
                    playerCastleCache.castleData.structureData,
                    previousCastleData.structureData
                )
            else
                -- PlayerCastleInitialized

                -- mutates player data, hence why we dont pass our current copy
                local castleCache = pushPlayerIntoVacantCastle(player)

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
    local structureConfig = CastleRenderSharedService.GetStructureConfig(structureID); do
        assert(structureConfig, `Structure ID {structureID} without valid config?`)
    end
    local purchaseableStructures = structureConfig.purchaseable

    -- mutate structure data
    do
        -- set unlocked to unlocked structure
        unlockedStructureData[2] = true

        -- set purchaseable to new progression structures
        for _, structureID in purchaseableStructures do
            local purchaseableStructureData = playerData.castle.structureData[structureID]
            if not purchaseableStructures then
                continue
            end

            purchaseableStructureData[1] = true
        end
    end

    for floorName in CastleRenderSharedService.FLOOR_NAMES:: {[string]: string} do
        local floorStructures = CastleRenderSharedService.FLOOR_END_STRUCTURES[floorName]; do
            assert(floorStructures, `Failed to acknowledge any structures from {floorName}`)
        end
        local endStructure = floorStructures["end"]
        local isFloorUnlocked = playerData.castle.floorUnlocked[floorName]

        if 
            endStructure == structureID
            and not isFloorUnlocked
        then
            playerData.castle.floorUnlocked[floorName] = true
        end
    end

    return true
end

return CastleServerService