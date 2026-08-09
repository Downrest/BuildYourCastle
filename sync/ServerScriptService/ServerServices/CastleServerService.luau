local ServerScriptService = game:GetService("ServerScriptService")

local ServerStorage = game:GetService("ServerStorage")

local MapServerService = require(ServerScriptService.ServerServices.MapServerService)

local CastleServerService = {}

CastleServerService.STRUCTURE_NAMES = {
    Pathway1 = "Pathway1";
}
CastleServerService.STRUCTURE_DATA = {
    [CastleServerService.STRUCTURE_NAMES.Pathway1] = {
        cost = {
            gold = 10;
        };
        progressFolder = "1. Pathway (10)";
    }
}



return CastleServerService
