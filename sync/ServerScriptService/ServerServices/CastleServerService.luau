local ServerScriptService = game:GetService("ServerScriptService")

local DataServerService = require(ServerScriptService.ServerServices.DataServerService)

local CastleServerService = {}

export type CastleData = DataServerService.CastleData
export type CastleCache = {
    owner: Player?;
    castleData: CastleData?;
}

CastleServerService.CastleCache = {}:: {CastleCache}

local MAX_CASTLES = 4

local function getPlayerCastleCache(player: Player): CastleCache?
    local castleCache = CastleServerService.CastleCache[1]; do
        local currentIndex = 0
        while castleCache.owner ~= player do
            currentIndex += 1
            castleCache = CastleServerService.CastleCache[currentIndex]
        end
    end

    return castleCache
end

local function getVacantCastleCache(): CastleCache?
    local vacantCastle = CastleServerService.CastleCache[1]; do
        local currentIndex = 0
        while not vacantCastle.owner do
            currentIndex += 1
            vacantCastle = CastleServerService.CastleCache[currentIndex]
        end
    end

    return vacantCastle
end

function CastleServerService.Init()
    for i = 1, MAX_CASTLES do
        CastleServerService.CastleCache = {
            owner = nil;
            castleData = nil;
        }
    end
end

function CastleServerService.GetPlayerCastleData(player: Player): CastleData
    local playerCastleCache = getPlayerCastleCache(player)
    local castleData = playerCastleCache and playerCastleCache.castleData; do
        if not castleData then
            castleData = DataServerService.GetPlayerData(player).castle
        end
    end

    return castleData:: DataServerService.CastleData
end

function CastleServerService.AddPlayerCastle(player: Player)
    local vacantCastle = getVacantCastleCache()
    assert(vacantCastle, "Attempted to add player castle when all castles are already occupied?")

    do
        vacantCastle.owner = player
        vacantCastle.castleData = CastleServerService.GetPlayerCastleData(player)
    end
end

return CastleServerService
