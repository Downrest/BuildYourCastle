local MapSharedService = {}

local mapFolder = workspace.Map
local shopFolder = mapFolder.Shops
local islandsFolder = mapFolder.Islands
local playerIslandsFolder = islandsFolder.Player
local mainIslandFolder = islandsFolder.Main
local lobbyIslandModel = mainIslandFolder.LobbyIsland

MapSharedService.MAP = workspace.Map
MapSharedService.SHOPS = {
    buildShop = shopFolder.BuildShop;
    gemShop = shopFolder.GemShop;
    petsShop = shopFolder.PetsShop;
    vipShop = shopFolder.VIPShop;
}
MapSharedService.LOBBY_ISLAND = lobbyIslandModel
MapSharedService.PLAYER_ISLAND_CONTAINER = playerIslandsFolder

return MapSharedService
