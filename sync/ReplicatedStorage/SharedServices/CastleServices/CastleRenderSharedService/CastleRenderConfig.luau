local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)
local MapSharedService = require(ReplicatedStorage.SharedServices.MapSharedService)
local StructureRenderConfig = require(script.Parent.StructureRenderConfig)

local CastleRenderConfig = {}

local lobbyIsland = MapSharedService.LOBBY_ISLAND
local castleAssets = AssetSharedService.CASTLE_ASSETS

local LOBBY_ISLAND_PIVOT = lobbyIsland:GetPivot()

export type CastleRenderData = {
	castleIslandModel: typeof(CastleRenderConfig.CASTLE_ISLAND_MODEL);
    unlockedRenderStructures: {
        [string]: StructureRenderConfig.StructureRenderData
    };
}

CastleRenderConfig.CASTLE_ISLAND_MODEL = castleAssets.CastleIsland
CastleRenderConfig.CASTLE_ISLAND_SIZE = CastleRenderConfig.CASTLE_ISLAND_MODEL:GetExtentsSize()
CastleRenderConfig.CASTLE_ID_DATA = {
    [1] = {
        cframe = LOBBY_ISLAND_PIVOT
            * CFrame.Angles(0, math.rad(-90), 0)
    };
    [2] = {
        cframe = LOBBY_ISLAND_PIVOT
            * CFrame.Angles(0, math.rad(0), 0)
    };
    [3] = {
        cframe = LOBBY_ISLAND_PIVOT
            * CFrame.Angles(0, math.rad(90), 0)
    };
    [4] = {
        cframe = LOBBY_ISLAND_PIVOT
            * CFrame.Angles(0, math.rad(180), 0)
    };
}

return CastleRenderConfig
