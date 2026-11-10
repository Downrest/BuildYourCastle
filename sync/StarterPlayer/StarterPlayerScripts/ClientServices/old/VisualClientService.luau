local VisualClientService = {}

export type VisualData = {
    defaults: {
        [BasePart]: {
            transparency: number;
            canCollide: boolean;
            collisionGroup: string;
        }
    }
}

type VisualModel =  Model

VisualClientService.VISUAL_FOLDER = workspace.Visual

local VISUAL_TRANSPARENCY = .25
local VISUAL_CAN_COLLIDE = false
local VISUAL_COLLISION_GROUP = "Visual"

local visualData = {}:: {[VisualModel]: VisualData}

local function initVisual(data: VisualData, VisualModel: VisualModel)
    for _, part in VisualModel:QueryDescendants("BasePart") do
        data.defaults[part] = {
            transparency = part.Transparency;
            canCollide = part.CanCollide;
            collisionGroup = part.CollisionGroup;
        }

        part.Transparency = VISUAL_TRANSPARENCY
        part.CanCollide = VISUAL_CAN_COLLIDE
        part.CollisionGroup = VISUAL_COLLISION_GROUP
    end
end

local function unwrapVisual(data: VisualData)
    for part, default in data.defaults do
        part.Transparency = default.transparency
        part.CanCollide = default.canCollide
        part.CollisionGroup = default.collisionGroup
    end
end

function VisualClientService.RegisterVisual<T>(VisualModel: VisualModel & T): T
    local data = visualData[VisualModel]
    if not data then
        data = {
            defaults = {};
        }
        initVisual(data, VisualModel)

        visualData[VisualModel] = data
    end
    
    VisualModel.Parent = VisualClientService.VISUAL_FOLDER
    
    return VisualModel
end

function VisualClientService.UnregisterVisual(VisualModel: VisualModel)
    if not visualData[VisualModel] then
        return
    end

    local data = visualData[VisualModel]
    unwrapVisual(data)

    VisualModel.Parent = nil
    visualData[VisualModel] = nil
end

return VisualClientService
	