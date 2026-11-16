local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StateMachineUtil = require(ReplicatedStorage.SharedUtils.StateMachineUtil)
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.BuildConfig)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)

local rotateHandleAsset = AssetSharedService.BUILD_MOVE_HANDLE_ASSETS.RotateHandles:Clone(); do
    rotateHandleAsset.Parent = BuildConfig.HANDLE_FOLDER
end
local origin = rotateHandleAsset.Origin
local upHandle = rotateHandleAsset.UpHandle
local upSphereAdornment = upHandle.SphereHandleAdornment
local downHandle = rotateHandleAsset.DownHandle
local downSphereAdornment = downHandle.SphereHandleAdornment
local leftHandle = rotateHandleAsset.LeftHandle
local leftSphereAdornment = leftHandle.SphereHandleAdornment
local rightHandle = rotateHandleAsset.RightHandle
local rightSphereAdornment = rightHandle.SphereHandleAdornment
local frontHandle = rotateHandleAsset.FrontHandle
local frontSphereAdornment = frontHandle.SphereHandleAdornment
local backHandle = rotateHandleAsset.BackHandle
local backSphereAdornment = backHandle.SphereHandleAdornment
local upDownArc = rotateHandleAsset.UpDownArc
local leftRightArc = rotateHandleAsset.LeftRightArc
local frontBackArc = rotateHandleAsset.FrontBackArc

local HANDLES = {
    [BuildClientService.HANDLE_DIRECTIONS.Up] = {
        handle = upHandle;
        motor = origin.UpHandle;
        dragDetector = upHandle.DragDetector;
        handleAdornment = upSphereAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Down] = {
        handle = downHandle;
        motor = origin.DownHandle;
        dragDetector = downHandle.DragDetector;
        handleAdornment = downSphereAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Left] = {
        handle = leftHandle;
        motor = origin.LeftHandle;
        dragDetector = leftHandle.DragDetector;
        handleAdornment = leftSphereAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Right] = {
        handle = rightHandle;
        motor = origin.RightHandle;
        dragDetector = rightHandle.DragDetector;
        handleAdornment = rightSphereAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Front] = {
        handle = frontHandle;
        motor = origin.FrontHandle;
        dragDetector = frontHandle.DragDetector;
        handleAdornment = frontSphereAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Back] = {
        handle = backHandle;
        motor = origin.BackHandle;
        dragDetector = backHandle.DragDetector;
        handleAdornment = backSphereAdornment;
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

local HANDLE_DATA = {
    handleModel = rotateHandleAsset;
    handleScale = rotateHandleAsset:GetScale();
    handleAdornmentDefaults = {
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.SphereHandleAdornment;
            asset = upSphereAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.SphereHandleAdornment;
            asset = downSphereAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.SphereHandleAdornment;
            asset = leftSphereAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.SphereHandleAdornment;
            asset = rightSphereAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.SphereHandleAdornment;
            asset = frontSphereAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.SphereHandleAdornment;
            asset = backSphereAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.CylinderHandleAdornment;
            asset = upDownArc;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.CylinderHandleAdornment;
            asset = leftRightArc;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.CylinderHandleAdornment;
            asset = frontBackArc;
        };
    }
}

local previousBuildCFrame: CFrame

local function initRotateHandles(buildData: BuildClientService.BuildData?)
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

return StateMachineUtil.state({
    Enter = function(bin)
        local currentBuildData = BuildClientService.CurrentBuildData()
        local currentBuildModel = currentBuildData.model; do
            previousBuildCFrame = currentBuildModel:GetPivot()
        end

        -- adapt rotate handles to build model
        do
            initRotateHandles(currentBuildData)
            BuildClientService.CurrentHandleData(HANDLE_DATA)
        end

        for direction, handleData in HANDLES do
            local dragDetector = handleData.dragDetector

            bin:Add(dragDetector.DragEnd:Connect(function()
                previousBuildCFrame = currentBuildModel:GetPivot()
            end))
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

                -- TODO: change CFrame.new(currentBuildModel:GetPivot().Position)
                currentBuildModel:PivotTo(
                    previousBuildCFrame * cframeAngles
                )
            end))
        end
    end;
    Exit = function()
        initRotateHandles(nil)
        BuildClientService.CurrentHandleData(BuildClientService.NIL_HANDLE_DATA)
    end;
})
