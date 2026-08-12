local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local Squash = require(ReplicatedStorage.SharedPackages.Squash)
local TypedEvent = require(ReplicatedStorage.SharedPackages.TypedEvent)
local MapSharedService = require(ReplicatedStorage.SharedServices.MapSharedService)
local CleanupUtil = require(ReplicatedStorage.SharedUtils.CleanupUtil)

local CastleSharedService = {}

local sharedAssets = ReplicatedStorage.SharedAssets
local castleAssets = sharedAssets.Castle
local castleIslandModel = castleAssets.CastleIsland
local castleProgressions = castleAssets.Progression

export type BatchedCastleReplication = {CastleReplication}
export type CastleReplication = {
    castleID: number;
    --[[
        {[structureName -> string]: isUnlocked -> boolean}
    ]]
    unlockedStructures: {[string]: boolean};
}

type StructureRenderData = {
    asset: any?;
    state: string;
    bin: {CleanupUtil.Trash?};
}
export type CastleRender = {
    castleIslandModel: typeof(castleIslandModel);
    unlockedRenderStructures: {
        [string]: StructureRenderData
    };
}
CastleSharedService.STRUCTURE_NAMES = {
	Pathway1 = "Pathway1";
}
CastleSharedService.STRUCTURE_NAME_TO_ASSET = {
    [CastleSharedService.STRUCTURE_NAMES.Pathway1] = castleProgressions["1. Pathway (10)"];
}
CastleSharedService.STRUCTURE_STATES = {
    ToPurchase = "ToPurchase";
    AlreadyPurchased = "AlreadyPurchased";
}

CastleSharedService.ClientReplicationReady =
    TypedEvent.newReliable("ClientReplicationReady"):: TypedEvent.ClientToServer<any>
CastleSharedService.ReplicationPacket =
    TypedEvent.newReliable("IslandReplicationPacket"):: TypedEvent.ServerToClient<(replicationBuffer: buffer) -> ()>

CastleSharedService.ClientTouchedStructurePurchase =
    TypedEvent.newReliable("IslandReplicationPacket"):: TypedEvent.ClientToServer<(structureID: string) -> ()>

CastleSharedService.StructurePurchaseTouched = 
    Signal.new<<(structureID: string, touchingPlayer: Player) -> ()>>()
CastleSharedService.StructureRendered = 
    Signal.new<<(structureRenderData: StructureRenderData, currentState: string) -> ()>>()
CastleSharedService.StructureStateChanged = 
    Signal.new<<(structureRenderData: StructureRenderData, newState: string, oldState: string) -> ()>>()
    
local ISLAND_ASSET = castleIslandModel
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
local BIN_TAGS = {
    PURCHASE_PAD_TOUCHED = "PurchasePadTouched"
}

local renderContainer
local castleRenderCache = {}:: {[number]: CastleRender}

--[[
    THE REPLICATION FORMAT IS AS FOLLOWS:

    `castleID` denotes the castle type to place structures in (client renders castle type if not existing yet)
    `unlockedStructures` denotes the structures in that castle type to be rendered, 
        L>  {
                [structureName -> string]: isUnlocked -> boolean
            }
]]
local castleReplicationSerde = Squash.record({
    castleID = Squash.T(Squash.i8());
    unlockedStructures = Squash.T(
        Squash.map<<string, boolean>>(
            Squash.string(),
            Squash.literal(true, false)
        )
    );
})
local batchCastleReplicationSerde = Squash.array(castleReplicationSerde);

function CastleSharedService.SerializeReplicationPacket(batchCastleReplication: BatchedCastleReplication): buffer
    local cursor = Squash.cursor()

    batchCastleReplicationSerde.ser(cursor, batchCastleReplication)

    return Squash.tobuffer(cursor)
end

function CastleSharedService.DeserializeReplicationPacket(batchCastleReplication: buffer): BatchedCastleReplication
    local cursor = Squash.frombuffer(batchCastleReplication)

    return batchCastleReplicationSerde.des(cursor)
end

function CastleSharedService.InitRender(preventReplication: boolean?)
    if preventReplication then
        renderContainer = Instance.new("Camera"); do
            renderContainer.Parent = MapSharedService.PLAYER_ISLAND_CONTAINER
        end
    else
        renderContainer = MapSharedService.PLAYER_ISLAND_CONTAINER
    end
end

function CastleSharedService.GetRenderCastle(castleID: number): CastleRender
    return castleRenderCache[castleID]
end

function CastleSharedService.RenderCastleReplication(castleReplication: CastleReplication)
    warn(`REPLICATING... `, castleReplication)
    assert(renderContainer, "Attempted to render castle replication without renderContainer!")

    local castleRender = CastleSharedService.GetRenderCastle(castleReplication.castleID)
    if not castleRender then
        -- cache castle render data + render island if necessary
        do
            local castleCFrame = CASTLE_ID_DATA[castleReplication.castleID].cframe
            local castleIslandModel = ISLAND_ASSET:Clone(); do
                castleIslandModel:PivotTo(castleCFrame)
                castleIslandModel.Parent = renderContainer
            end

            local newCastleRender = {
                castleIslandModel = castleIslandModel;
                unlockedRenderStructures = {
                    asset = nil;
                    bin = {};
                };
            }
            castleRenderCache[castleReplication.castleID] = newCastleRender:: CastleRender

            castleRender = castleRenderCache[castleReplication.castleID]
        end
    end

    -- render structures
    do
        for unlockedStructureID, isUnlocked in castleReplication.unlockedStructures do
            local unlockedStructureData = castleRender.unlockedRenderStructures[unlockedStructureID] 

            local previousState = unlockedStructureData.state
            local currentState = isUnlocked
                and CastleSharedService.STRUCTURE_STATES.AlreadyPurchased
                or CastleSharedService.STRUCTURE_STATES.ToPurchase
            
            if not unlockedStructureData.asset then
                local STRUCTURE_ASSET = CastleSharedService.STRUCTURE_NAME_TO_ASSET[unlockedStructureID]
                
                local structureModel = STRUCTURE_ASSET:Clone(); do
                    structureModel:PivotTo(castleRender.castleIslandModel:GetPivot())
                    structureModel.Parent = castleRender.castleIslandModel.Progression.ClientRender
    
                    unlockedStructureData.asset = structureModel
                end

                -- purchase pad touched
                do
                    local purchasePad = structureModel.PurchasePad
                    local hitboxPart = purchasePad.Hitbox:: BasePart

                    CleanupUtil.InsertBin(unlockedStructureData.bin, 
                        hitboxPart.Touched:Connect(function(part)
                            local character = part:FindFirstAncestorWhichIsA("Model")
                            local player = character and Players:GetPlayerFromCharacter(character)
                            if not player then
                                return
                            end

                            CastleSharedService.StructurePurchaseTouched:Fire(unlockedStructureID, player)
                        end), BIN_TAGS.PURCHASE_PAD_TOUCHED
                    )
                end

                -- update state
                do
                    unlockedStructureData.state = currentState
                    CastleSharedService.StructureRendered:Fire(
                        unlockedStructureData,
                        currentState
                    )
                end
            else
                -- update state
                do
                    if unlockedStructureData.state ~= currentState then
                        unlockedStructureData.state = currentState
                        CastleSharedService.StructureStateChanged:Fire(
                            unlockedStructureData,
                            currentState,
                            previousState
                        )
                    end
                end
            end
        end
    end
end

return CastleSharedService
