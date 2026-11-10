local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local BuildConfig = require(ReplicatedStorage.SharedConfigs.CastleConfig.BuildConfig)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local GuiClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiClientService)
local VisualClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.VisualClientService)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)

local BuildController = {}

type BuildData = {
    model: Model;
        modelSize: Vector3;
        adorneePart: BasePart;
}
type HandleData = {
    instance: ConeHandleAdornment; 
    direction: string;
}

local HANDLE_DIRECTIONS = {
    Up = "Up";
    Down = "Down";
    Front = "Front";
    Back = "Back";
    Left = "Left";
    Right = "Right";
}
local HANDLE_DIRECTIONS_TO_VECTOR = {
    [HANDLE_DIRECTIONS.Up] = Vector3.yAxis;
    [HANDLE_DIRECTIONS.Down] = -Vector3.yAxis;
    [HANDLE_DIRECTIONS.Front] = -Vector3.zAxis;
    [HANDLE_DIRECTIONS.Back] = Vector3.zAxis;
    [HANDLE_DIRECTIONS.Left] = -Vector3.xAxis;
    [HANDLE_DIRECTIONS.Right] = Vector3.xAxis;
}
local VERTICAL_DIRECTION = { HANDLE_DIRECTIONS.Up, HANDLE_DIRECTIONS.Down }
local FORWARD_DIRECTION = { HANDLE_DIRECTIONS.Front, HANDLE_DIRECTIONS.Back }
local HORIZONTAL_DIRECTION = { HANDLE_DIRECTIONS.Left, HANDLE_DIRECTIONS.Right }
local BUILD_RAY_PARAMS = RaycastParams.new(); do
    -- TODO: have another script automatically register char into character collision group
    BUILD_RAY_PARAMS.FilterDescendantsInstances = {
        LocalPlayerUtil.character
    }
    BUILD_RAY_PARAMS.FilterType = Enum.RaycastFilterType.Exclude
end
local INIT_BUILD_RAY_DIST = 10

local camera = workspace.CurrentCamera
local buildGui = GuiClientService.BuildMode
local buildHandles = buildGui.Handles
local handleInstances = {
    up = { instance = buildHandles.UpHandle; direction = HANDLE_DIRECTIONS.Up };
    down = { instance = buildHandles.DownHandle; direction = HANDLE_DIRECTIONS.Down };
    front = { instance = buildHandles.FrontHandle; direction = HANDLE_DIRECTIONS.Front };
    back = { instance = buildHandles.BackHandle; direction = HANDLE_DIRECTIONS.Back };
    left = { instance = buildHandles.LeftHandle; direction = HANDLE_DIRECTIONS.Left };
    right = { instance = buildHandles.RightHandle; direction = HANDLE_DIRECTIONS.Right };
}:: {[string]: HandleData}

local buildBin = Janitor.new()
local buildModelCache = {}:: {[string]: BuildData}
local currentBuildName: string?

local function cacheBuildModel(buildName: string)
    local buildModel = BuildConfig.BUILD_TO_ASSET[buildName]:Clone()

    buildModelCache[buildName] = {
        model = buildModel;
        modelSize = buildModel:GetExtentsSize();
        adorneePart = (buildModel.PrimaryPart or buildModel:FindFirstChildWhichIsA("BasePart")):: BasePart;
    }
end

local function getHandleSizeOffset(handleDirection: string, buildData: BuildData): number
    local modelHalfSize = buildData.modelSize / 2

    if table.find(VERTICAL_DIRECTION, handleDirection) then
        return modelHalfSize.Y
    elseif table.find(FORWARD_DIRECTION, handleDirection) then
        return modelHalfSize.Z
    elseif table.find(HORIZONTAL_DIRECTION, handleDirection) then
        return modelHalfSize.X
    end
    return 0
end

local function toggleHandles(isEnabled: boolean, buildName: string?): ()
    if isEnabled then
        buildName = (buildName:: string)

        local buildData = buildModelCache[buildName]

        for _, handleData in handleInstances do
            local handleInstance = handleData.instance

            local sizeOffset = getHandleSizeOffset(handleData.direction, buildData)
            local directionVector = HANDLE_DIRECTIONS_TO_VECTOR[handleData.direction]

            handleInstance.Visible = true
            handleInstance.Adornee = buildData.adorneePart
            handleInstance.CFrame = CFrame.lookAlong(directionVector * sizeOffset, directionVector)
        end
    else
        for _, handleData in handleInstances do
            handleData.instance.Visible = false
        end
    end
end

local function cleanupCurrentBuild()
    local buildData = currentBuildName and buildModelCache[currentBuildName]
    if buildData then
        VisualClientService.UnregisterVisual(buildData.model)
        currentBuildName = nil
    end
end

local function getInitBuildCFrame(): CFrame
    local cameraCFrame = camera.CFrame
    local clampedCameraLook = cameraCFrame.LookVector.Unit * INIT_BUILD_RAY_DIST
    local frontRay = workspace:Raycast(
        cameraCFrame.Position,
        clampedCameraLook,
        BUILD_RAY_PARAMS
    )

    if frontRay then
        return CFrame.new(frontRay.Position)
    else
        return CFrame.new(cameraCFrame.Position + clampedCameraLook)
    end
end

function BuildController.Init()
    for buildName in BuildConfig.BUILD_NAMES:: {[string]: string} do
        cacheBuildModel(buildName)
    end
    toggleHandles(false)
end

function BuildController.Mount()
    buildBin:Add(Vide.root(function()
        -- Vide.effect(function()
        --     local 
        --     if BuildClientService.CurrentButtonSelection() then
                
        --     end

        --     warn(BuildClientService.CurrentButtonSelection())
        -- end)

        -- new build selection
        Vide.effect(function()
            cleanupCurrentBuild()

            currentBuildName = BuildClientService.CurrentBuildSelected()
            if currentBuildName ~= "" then
                -- build select
                local buildData = buildModelCache[currentBuildName]
                local buildModel = buildData.model

                VisualClientService.RegisterVisual(
                    buildModel
                )
                buildModel:PivotTo( 
                    getInitBuildCFrame()
                )

                toggleHandles(true, currentBuildName)
            else
                -- build deselect
                toggleHandles(false)
            end
        end)
    end))

    buildBin:Add(RunService.RenderStepped:Connect(function(delta)

    end))
end

function BuildController.Dismount()
    buildBin:Cleanup()
end

return BuildController