local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CastleSharedService = require(ReplicatedStorage.SharedServices.CastleSharedService)
local MapSharedService = require(ReplicatedStorage.SharedServices.MapSharedService)

local ReplicationController = {}

local CASTLE_ID_DATA = {
    [1] = {
        cframe = MapSharedService.LOBBY_ISLAND:GetPivot()
            * CFrame.Angles(0, math.rad(-90), 0)
    };
    [2] = {
        cframe = MapSharedService.LOBBY_ISLAND:GetPivot()
            * CFrame.Angles(0, math.rad(0), 0)
    };
    [3] = {
        cframe = MapSharedService.LOBBY_ISLAND:GetPivot()
            * CFrame.Angles(0, math.rad(90), 0)
    };
    [4] = {
        cframe = MapSharedService.LOBBY_ISLAND:GetPivot()
            * CFrame.Angles(0, math.rad(180), 0)
    };
}

export type CastleRender = {
    castleIslandModel: typeof(CastleSharedService.ISLAND_ASSET);
    unlockedStructures: {string};
}

local castleRenderCache = {}:: {[number]: CastleRender}

function ReplicationController.RenderCastleReplication(castleReplication: CastleSharedService.CastleReplication)
    local castleRender: CastleRender = castleRenderCache[castleReplication.castleID]
    if not castleRender then
        -- cache castle render data + render island if necessary
        do
            local castleCFrame = CASTLE_ID_DATA[castleReplication.castleID].cframe
            local castleIslandModel = CastleSharedService.ISLAND_ASSET:Clone(); do
                castleIslandModel:PivotTo(castleCFrame)
                castleIslandModel.Parent = MapSharedService.PLAYER_ISLAND_CONTAINER
            end

            local newCastleRender = {
                castleIslandModel = castleIslandModel;
                unlockedStructures = castleReplication.unlockedStructures;
            }
            castleRenderCache[castleReplication.castleID] = newCastleRender:: CastleRender

            castleRender = castleRenderCache[castleReplication.castleID]
        end
    end

    -- render structures
    do
        for _, unlockedStructureID in castleReplication.unlockedStructures do
            local STRUCTURE_ASSET = CastleSharedService.STRUCTURE_NAME_TO_ASSET[unlockedStructureID]
            
            local structureModel = STRUCTURE_ASSET:Clone(); do
                structureModel:PivotTo(castleRender.castleIslandModel:GetPivot())
                structureModel.Parent = castleRender.castleIslandModel.Progression
            end
        end
    end
end

function ReplicationController.Init()
    CastleSharedService.ClientReplicationReady.client:FireServer()

    CastleSharedService.ReplicationPacket.client.OnClientEvent:Connect(function(
        replicationBuffer
    )
        local batchedCastleReplication = CastleSharedService.DeserializeReplicationPacket(
            replicationBuffer
        )

        for _, castleReplication in batchedCastleReplication do
            ReplicationController.RenderCastleReplication(castleReplication)
        end
    end)
end

return ReplicationController
