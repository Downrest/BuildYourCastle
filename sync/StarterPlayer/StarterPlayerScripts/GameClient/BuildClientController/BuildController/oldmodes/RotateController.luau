local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.BuildConfig)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)

local RotateController = {}

local rotateHandleAsset = AssetSharedService.BUILD_MOVE_HANDLE_ASSETS.RotateHandles:Clone(); do
    rotateHandleAsset.Parent = BuildConfig.HANDLE_FOLDER
end
local origin = rotateHandleAsset.Origin
local upHandle = rotateHandleAsset.UpHandle
local downHandle = rotateHandleAsset.DownHandle
local leftHandle = rotateHandleAsset.LeftHandle
local rightHandle = rotateHandleAsset.RightHandle
local frontHandle = rotateHandleAsset.FrontHandle
local backHandle = rotateHandleAsset.BackHandle
local upDownArc = rotateHandleAsset.UpDownArc
local leftRightArc = rotateHandleAsset.LeftRightArc
local frontBackArc = rotateHandleAsset.FrontBackArc

local bin = Janitor.new()

local HANDLES = {
    [BuildClientService.HANDLE_DIRECTIONS.Up] = {
        handle = upHandle;
        motor = origin.UpHandle;
        dragDetector = upHandle.DragDetector;
        handleAdornment = upHandle.SphereHandleAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Down] = {
        handle = downHandle;
        motor = origin.DownHandle;
        dragDetector = downHandle.DragDetector;
        handleAdornment = downHandle.SphereHandleAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Left] = {
        handle = leftHandle;
        motor = origin.LeftHandle;
        dragDetector = leftHandle.DragDetector;
        handleAdornment = leftHandle.SphereHandleAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Right] = {
        handle = rightHandle;
        motor = origin.RightHandle;
        dragDetector = rightHandle.DragDetector;
        handleAdornment = rightHandle.SphereHandleAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Front] = {
        handle = frontHandle;
        motor = origin.FrontHandle;
        dragDetector = frontHandle.DragDetector;
        handleAdornment = frontHandle.SphereHandleAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Back] = {
        handle = backHandle;
        motor = origin.BackHandle;
        dragDetector = backHandle.DragDetector;
        handleAdornment = backHandle.SphereHandleAdornment;
    };
}
local HANDLE_ARCS = { upDownArc, leftRightArc, frontBackArc }
local HANDLE_OFFSETS = {
    [BuildClientService.HANDLE_DIRECTIONS.Up] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(0, (boundingHalfSize.Y), 0)
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Down] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(0, -(boundingHalfSize.Y), 0)
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Left] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(0, 0, (boundingHalfSize.Z))
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Right] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(0, 0, -(boundingHalfSize.Z))
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Front] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new((boundingHalfSize.X), 0, 0)
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Back] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(-(boundingHalfSize.X), 0, 0)
    end;
}:: {[string]: (Vector3) -> CFrame}

local ARC_RADIUS_SPACING = .1

local function adaptRotateHandles(buildData: BuildClientService.BuildData?)
    local rotateHandleParent: Instance, rotateHandleCFrame: CFrame

    if buildData then
        local buildModel = buildData.model
        local buildCFrame = buildModel:GetPivot()

        local boundingMagnitude, boundingHalfSize; do
            local buildHalfSize = buildData.modelSize

            boundingMagnitude = math.max(buildHalfSize.X, buildHalfSize.Y, buildHalfSize.Z) + BuildClientService.HANDLE_OFFSET
            boundingHalfSize = Vector3.one * (boundingMagnitude)
        end

        -- handles + arcs
        do
            for direction, handleData in HANDLES do
                local handleOffset = HANDLE_OFFSETS[direction]

                handleData.motor.C0 = handleOffset(boundingHalfSize)
            end
            for _, handleArc in HANDLE_ARCS do
                handleArc.InnerRadius = boundingMagnitude
                handleArc.Radius = boundingMagnitude + ARC_RADIUS_SPACING
            end
        end

        rotateHandleParent = buildModel
        rotateHandleCFrame = buildCFrame
    else
        rotateHandleParent = BuildConfig.HANDLE_FOLDER
        rotateHandleCFrame = BuildClientService.HANDLE_UNRENDER_CFRAME
    end

    rotateHandleAsset.Parent = rotateHandleParent
    rotateHandleAsset:PivotTo(rotateHandleCFrame)
end

local function mountRotate()
    local currentBuildData = BuildClientService.CurrentBuildData()
    local currentBuildModel = currentBuildData.model

    do
        adaptRotateHandles(currentBuildData)
        BuildClientService.CurrentHandleData({
            handleModel = rotateHandleAsset;
        })
    end

    for direction, handleData in HANDLES do
        local dragDetector = handleData.dragDetector

        bin:Add(dragDetector.DragContinue:Connect(function()
            local x, y, z = dragDetector.DragFrame:ToEulerAnglesXYZ()
            local cframeAngles: CFrame

            if table.find(BuildClientService.HANDLE_DIRECTION_GROUPS.UpDown, direction) then
                cframeAngles = CFrame.Angles(0, 0, z)
            elseif table.find(BuildClientService.HANDLE_DIRECTION_GROUPS.LeftRight, direction) then
                cframeAngles = CFrame.Angles(x, 0, 0)
            elseif table.find(BuildClientService.HANDLE_DIRECTION_GROUPS.FrontBack, direction) then
                cframeAngles = CFrame.Angles(0, y, 0)
            end

            currentBuildModel:PivotTo(
                CFrame.new(currentBuildModel:GetPivot().Position) * cframeAngles
            )
        end))
    end
end

local function dismountRotate()
    adaptRotateHandles(nil)

    bin:Cleanup()
end

function RotateController.Init()
    dismountRotate()

    --TODO: look into bug when u switch modes n whatnot
	Vide.effect(function()
        if BuildGuiService.CurrentMode() == BuildGuiService.BUTTON_SELECTIONS.Rotate then
            mountRotate()
        else
            dismountRotate()
        end
	end)
end

return RotateController
