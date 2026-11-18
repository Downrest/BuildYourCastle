local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local BuildConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.BuildConfig)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)
local StateMachineUtil = require(ReplicatedStorage.SharedUtils.StateMachineUtil)


local moveHandleAsset = AssetSharedService.BUILD_MOVE_HANDLE_ASSETS.MoveHandles:Clone(); do
    moveHandleAsset.Parent = BuildConfig.HANDLE_FOLDER
end
local origin = moveHandleAsset.Origin
local upHandle = moveHandleAsset.UpHandle
local upConeAdornment = upHandle.ConeHandleAdornment
local downHandle = moveHandleAsset.DownHandle
local downConeAdornment = downHandle.ConeHandleAdornment
local leftHandle = moveHandleAsset.LeftHandle
local leftConeAdornment = leftHandle.ConeHandleAdornment
local rightHandle = moveHandleAsset.RightHandle
local rightConeAdornment = rightHandle.ConeHandleAdornment
local frontHandle = moveHandleAsset.FrontHandle
local frontConeAdornment = frontHandle.ConeHandleAdornment
local backHandle = moveHandleAsset.BackHandle
local backConeAdornment = backHandle.ConeHandleAdornment

local HANDLES = {
    [BuildClientService.HANDLE_DIRECTIONS.Up] = {
        handle = upHandle;
        motor = origin.UpHandle;
        dragDetector = upHandle.DragDetector;
        handleAdornment = upConeAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Down] = {
        handle = downHandle;
        motor = origin.DownHandle;
        dragDetector = downHandle.DragDetector;
        handleAdornment = downConeAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Left] = {
        handle = leftHandle;
        motor = origin.LeftHandle;
        dragDetector = leftHandle.DragDetector;
        handleAdornment = leftConeAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Right] = {
        handle = rightHandle;
        motor = origin.RightHandle;
        dragDetector = rightHandle.DragDetector;
        handleAdornment = rightConeAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Front] = {
        handle = frontHandle;
        motor = origin.FrontHandle;
        dragDetector = frontHandle.DragDetector;
        handleAdornment = frontConeAdornment;
    };
    [BuildClientService.HANDLE_DIRECTIONS.Back] = {
        handle = backHandle;
        motor = origin.BackHandle;
        dragDetector = backHandle.DragDetector;
        handleAdornment = backConeAdornment;
    };
}
local HANDLE_OFFSETS = {
    [BuildClientService.HANDLE_DIRECTIONS.Up] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(0, (boundingHalfSize.Y), 0)
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Down] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(0, -(boundingHalfSize.Y), 0)
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Left] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(0, 0, -(boundingHalfSize.Z))
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Right] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(0, 0, (boundingHalfSize.Z))
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Front] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new((boundingHalfSize.X), 0, 0)
    end;
    [BuildClientService.HANDLE_DIRECTIONS.Back] = function(boundingHalfSize: Vector3): CFrame
        return CFrame.new(-(boundingHalfSize.X), 0, 0)
    end;
}:: {[string]: (Vector3) -> CFrame}

local HANDLE_DATA = {
    handleModel = moveHandleAsset;
    handleScale = moveHandleAsset:GetScale();
    handleAdornmentDefaults = {
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.ConeHandleAdornment;
            asset = upConeAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.ConeHandleAdornment;
            asset = downConeAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.ConeHandleAdornment;
            asset = leftConeAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.ConeHandleAdornment;
            asset = rightConeAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.ConeHandleAdornment;
            asset = frontConeAdornment;
        };
        {
            type = BuildClientService.HANDLE_ADORNMENT_TYPES.ConeHandleAdornment;
            asset = backConeAdornment;
        };
    }
}

local previousBuildCFrame: CFrame

local function initRotateHandles(buildData: BuildClientService.BuildData?)
    local rotateHandleCFrame: CFrame

    if buildData then
        local buildModel = buildData.model
        local buildCFrame = buildModel:GetPivot()

        -- fyi this math relies on handle model being GetScale() == 1
        local boundingHalfSize; do
            local buildHalfSize = buildData.modelSize
            local boundingHalfMagnitude = math.max(buildHalfSize.X, buildHalfSize.Y, buildHalfSize.Z) + BuildClientService.HANDLE_OFFSET

            boundingHalfSize = Vector3.one * boundingHalfMagnitude
        end

        -- handles + arcs
        do
            for direction, handleData in HANDLES do
                local handleOffset = HANDLE_OFFSETS[direction]

                handleData.motor.C0 = handleOffset(boundingHalfSize)
            end
        end

        rotateHandleCFrame = buildCFrame
    else
        rotateHandleCFrame = BuildClientService.HANDLE_UNRENDER_CFRAME
    end

    moveHandleAsset:PivotTo(rotateHandleCFrame)
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
                local dragFrameCFrame = dragDetector.DragFrame
                local x, y, z = dragFrameCFrame.X, dragFrameCFrame.Y, dragFrameCFrame.Z

                local cframeDelta: CFrame

                if table.find(BuildClientService.HANDLE_DIRECTION_GROUPS.UpDown, direction) then
                    cframeDelta = CFrame.new(0, y, 0)
                elseif table.find(BuildClientService.HANDLE_DIRECTION_GROUPS.LeftRight, direction) then
                    cframeDelta = CFrame.new(0, 0, z)
                elseif table.find(BuildClientService.HANDLE_DIRECTION_GROUPS.FrontBack, direction) then
                    cframeDelta = CFrame.new(x, 0, 0)
                end

                currentBuildModel:PivotTo(
                    previousBuildCFrame * cframeDelta
                )
            end))
        end
    end;
    Exit = function()
        initRotateHandles(nil)
        BuildClientService.CurrentHandleData(BuildClientService.NIL_HANDLE_DATA)
    end;
})
