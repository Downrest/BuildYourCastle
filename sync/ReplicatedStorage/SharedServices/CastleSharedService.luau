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

export type StructureAsset = Model & {
    Assets: Instance;
    PurchasePad: {
        Button: Instance;
        Hitbox: Instance;
    };
}
export type StructureRenderData = {
    asset: StructureAsset;
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
    TypedEvent.newReliable("ReplicationPacket"):: TypedEvent.ServerToClient<(replicationBuffer: buffer) -> ()>

CastleSharedService.ClientTouchedStructurePurchase =
    TypedEvent.newReliable("ClientTouchedStructurePurchase"):: TypedEvent.ClientToServer<(structureID: string) -> ()>
CastleSharedService.ServerPurchaseStatus =
    TypedEvent.newReliable("ServerPurchaseStatus"):: TypedEvent.ServerToClient<(purchaseSuccess: boolean) -> ()>

CastleSharedService.StructurePurchaseTouched = 
    Signal.new<<(structureID: string, touchingPlayer: Player) -> ()>>()
CastleSharedService.StructureRendered = 
    Signal.new<<(structureAsset: StructureAsset, currentState: string) -> ()>>()
CastleSharedService.StructureStateChanged = 
    Signal.new<<(structureAsset: StructureAsset, newState: string, oldState: string) -> ()>>()
    
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
local PURCHASE_TOUCHED_DEBOUNCE = .5

local renderContainer
local castleRenderCache = {}:: {[number]: CastleRender}
local purchaseDebounces = {}:: {[string]: boolean}

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
    warn("ATTEMPT TO SERIALIZE!!!! ", batchCastleReplication)

    local cursor = Squash.cursor()

    batchCastleReplicationSerde.ser(cursor, batchCastleReplication)

    return Squash.tobuffer(cursor)
end

function CastleSharedService.DeserializeReplicationPacket(replicationBuffer: buffer): BatchedCastleReplication
    warn("ATTEMPT TO DESERIALIZE!!!! ", replicationBuffer)

    local cursor = Squash.frombuffer(replicationBuffer)

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

    local castleRender = CastleSharedService.GetRenderCastle(castleReplication.castleID); do
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
                    unlockedRenderStructures = {};
                }
                castleRenderCache[castleReplication.castleID] = newCastleRender:: CastleRender
    
                castleRender = castleRenderCache[castleReplication.castleID]
            end
        end 
    end

    -- render structures
    do
        for unlockedStructureID, isUnlocked in castleReplication.unlockedStructures do
            local unlockedStructureData = castleRender.unlockedRenderStructures[unlockedStructureID]
            local currentState = isUnlocked
                and CastleSharedService.STRUCTURE_STATES.AlreadyPurchased
                or CastleSharedService.STRUCTURE_STATES.ToPurchase

            -- change existing structure state
            if unlockedStructureData then
                local previousState = unlockedStructureData.state
                local structureBin = unlockedStructureData.bin

                if unlockedStructureData.state ~= currentState then
                    unlockedStructureData.state = currentState
                    CastleSharedService.StructureStateChanged:Fire(
                        unlockedStructureData.asset,
                        currentState,
                        previousState
                    )

                    CleanupUtil.Clean(structureBin, BIN_TAGS.PURCHASE_PAD_TOUCHED)
                    purchaseDebounces[unlockedStructureID] = nil
                end

            -- create new structure + state
            else
                local STRUCTURE_ASSET = CastleSharedService.STRUCTURE_NAME_TO_ASSET[unlockedStructureID]

                local structureModel = STRUCTURE_ASSET:Clone(); do
                    structureModel:PivotTo(castleRender.castleIslandModel:GetPivot())
                    structureModel.Parent = castleRender.castleIslandModel.Progression.ClientRender
                end
                local structureBin = {}

                -- purchase pad touched
                do
                    local purchasePad = structureModel.PurchasePad
                    local hitboxPart = purchasePad.Hitbox:: BasePart

                    purchaseDebounces[unlockedStructureID] = false

                    CleanupUtil.InsertBin(structureBin, 
                        hitboxPart.Touched:Connect(function(part)
                            if purchaseDebounces[unlockedStructureID] then
                                return
                            end

                            local character = part:FindFirstAncestorWhichIsA("Model")
                            local player = character and Players:GetPlayerFromCharacter(character)
                            if not player then
                                return
                            end

                            purchaseDebounces[unlockedStructureID] = true
                            task.delay(PURCHASE_TOUCHED_DEBOUNCE, function()
                                purchaseDebounces[unlockedStructureID] = false
                            end)

                            CastleSharedService.StructurePurchaseTouched:Fire(unlockedStructureID, player)

                        end), BIN_TAGS.PURCHASE_PAD_TOUCHED
                    )
                end

                unlockedStructureData = {
                    asset = structureModel;
                    state = currentState;
                    bin = structureBin;
                }

                -- update state
                do
                    castleRender.unlockedRenderStructures[unlockedStructureID] = unlockedStructureData:: any

                    CastleSharedService.StructureRendered:Fire(
                        unlockedStructureData.asset:: any,
                        currentState
                    )
                end
            end
        end
    end
end

return CastleSharedService
