local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CastleServerService = {}

export type CastleData = DataServerService.CastleData
export type CastleCache = {
    owner: Player?;
    castleData: CastleData?;
    castleID: number;
}

CastleServerService.CastleCache = {}:: {CastleCache}

local MAX_CASTLES = 4

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

function CastleServerService.Init()
    -- initializing castle cache
    do
        for i = 1, MAX_CASTLES do
            table.insert(
                CastleServerService.CastleCache,
                {
                    owner = nil;
                    castleData = nil;
                    castleID = i;
                }
            )
        end
    end
end

function CastleServerService.GetPlayerCastleCache(player: Player): CastleCache?
    return getPlayerCastleCache(player)
end

function CastleServerService.GetCastleCaches(): {CastleCache}
    return CastleServerService.CastleCache
end

function CastleServerService.AddPlayerCastle(player: Player): CastleCache
    local vacantCastle = getVacantCastleCache()
    assert(vacantCastle, "Attempted to add player castle when all castles are already occupied?")

    do
        vacantCastle.owner = player
        vacantCastle.castleData = getPlayerCastleData(player)
    end

    return vacantCastle
end

return CastleServerService
