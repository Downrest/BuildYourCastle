local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Lyra = require(ReplicatedStorage.SharedPackages.Lyra)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local t = require(ReplicatedStorage.SharedPackages.t)
local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local DataServerService = {}

export type CurrencyData = {
    gold: number;
}

export type CastleStructureData = {
    --[[
        [structureID -> string]
    ]]
    [string]: 
    --[[
        {isPurchaseable -> boolean, isUnlocked -> boolean}
    ]]
        {boolean};
}
export type CastleData = {
    popularity: number;
    --[[
        [structureID -> string]: {isPurchaseable -> boolean, isUnlocked -> boolean}
    ]]
    structureData: CastleStructureData;
}

export type PlayerData = {
    currency: CurrencyData;
    castle: CastleData;
}

local STARTING_PLAYER_GOLD = 15_400

DataServerService.DataServiceInitialized = Signal.new()
DataServerService.PlayerDataChanged = Signal.new<<(player: Player, newData: PlayerData, oldData: PlayerData?) -> ()>>()
DataServerService.PlayerDataLoaded = Signal.new<<(player: Player) -> ()>>()
DataServerService.PlayerDataReleased = Signal.new<<(player: Player) -> ()>>()

local playersDataLoaded = {}:: {Player}
local playersInitiallyReplicated = {}:: {Player}
local playerStore = Lyra.createPlayerStore<<PlayerData>>({
    name = "PlayerData";
    template = {
        currency = {
            gold = STARTING_PLAYER_GOLD;
        };
        castle = {
            popularity = 0;
            structureData = {
                -- 1ST FLOOR
                [CastleSharedService.STRUCTURE_NAMES.Pathway1] = { true, false };
                [CastleSharedService.STRUCTURE_NAMES.Bushes1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Bushes2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Staircase1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Lamps1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Staircase2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Fountain1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Lamps2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Walls1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Banner1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Bush1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.CastleTower1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Banner2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Bush2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.CastleTower2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Floor1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Entrance1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Walls2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Windows1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Windows2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Columns1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Lamps3] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Columns2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Lamps4] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Carpet1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Walls3] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Columns3] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Doorways1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Walls4] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Columns4] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Windows3] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Walls5] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Columns5] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Doorways2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Walls6] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Columns6] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Windows4] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Wall1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Wall2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Staircase3] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Carpet2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Display1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Wall3] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Wall4] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Ceiling1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Plants1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Candelabras1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Chandeliers1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Knights1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Carpet3] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Decorations1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Piano1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Decorations2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Banner3AndPainting1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Knights2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Candelabras2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Chandeliers2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Decorations3] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.ChessTable1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Decorations4] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Painting2] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.AngelStatue1] = { false, false };
                [CastleSharedService.STRUCTURE_NAMES.Banner4] = { false, false };
            };
        };
    };
    schema = t.strictInterface({
        currency = t.strictInterface({
            gold = t.number;
        });
        castle = t.strictInterface({
            popularity = t.number;
            structureData = t.map(
                t.string,
                t.array(t.boolean)
            );
        })
    });
    changedCallbacks = {
        function(userId, newData, oldData)
            local player = Players:GetPlayerByUserId(tonumber(userId):: number)
            assert(player, `Failed to translate {userId} into player?`)

            -- reject initial loaded callbacks
            if not table.find(playersDataLoaded, player) then
                return
            end

            DataServerService.PlayerDataChanged:Fire(player, newData, oldData)
        end;
    };
    
    -- TESTING...
    -- logCallback = function()
    --     if RunService:IsStudio() then
    --         -- Show all logs in Studio
    --         return function(message)
    --             print(`[Lyra][{message.level}] {message.message}`)
    --             if message.context then
    --                 print("Context:", message.context)
    --             end
    --         end
    --     else
    --         -- Only show errors in production
    --         return function(message)
    --             if message.level == "error" or message.level == "fatal" then
    --                 warn(`[Lyra] {message.message}`)
    --             end
    --         end
    --     end
    -- end;
})

local function playerAdded(player: Player)
    if table.find(playersDataLoaded, player) then
        return
    end

    table.insert(playersDataLoaded, player)
    playerStore:loadAsync(player)
    DataServerService.PlayerDataLoaded:Fire(player)
end

local function playerRemoving(player: Player)
    assert(table.find(playersDataLoaded, player), "Player was not loaded initially? Must be a bug")

    table.remove(playersDataLoaded, table.find(playersDataLoaded, player))
    playerStore:unloadAsync(player)
    DataServerService.PlayerDataReleased:Fire(player)
end

function DataServerService.Init()
    -- client handshake, "im ready for data replication!"
    DataSharedService.ClientDataReady.server.OnServerEvent:Connect(function(player)
        if not table.find(playersInitiallyReplicated, player) then
            return
        end

        table.insert(playersInitiallyReplicated, player)
        DataServerService.PlayerDataChanged:Fire(player, playerStore:getAsync(player))
    end)

    -- player added
    do
        for _, player in Players:GetPlayers() do
            playerAdded(player)
        end
        Players.PlayerAdded:Connect(function(player)
            playerAdded(player)
        end)
    end

    -- player removing
    Players.PlayerRemoving:Connect(function(player)
        playerRemoving(player)
    end)

    game:BindToClose(function()
        playerStore:closeAsync()
    end)

    -- execute service initialized
    DataServerService.DataServiceInitialized:Fire()
end

function DataServerService.GetPlayerDataAsync(player: Player): PlayerData
    return playerStore:getAsync(player)
end

function DataServerService.SetPlayerDataAsync(player: Player, setCallback: (data: PlayerData) -> boolean): boolean
    return playerStore:updateAsync(player, function(data)
        return setCallback(data)
    end)
end

return DataServerService
