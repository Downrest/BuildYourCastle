local MapServerService = {}

local mapFolder = workspace.Map
local shopFolder = mapFolder.Shops
local islandsFolder = mapFolder.Islands
local playerIslandsFolder = islandsFolder.Player
local mainIslandFolder = islandsFolder.Main
local lobbyIslandModel = mainIslandFolder.LobbyIsland

MapServerService.MAP = workspace.Map
MapServerService.SHOPS = {
    buildShop = shopFolder.BuildShop;
    gemShop = shopFolder.GemShop;
    petsShop = shopFolder.PetsShop;
    vipShop = shopFolder.VIPShop;
}

return MapServerService
