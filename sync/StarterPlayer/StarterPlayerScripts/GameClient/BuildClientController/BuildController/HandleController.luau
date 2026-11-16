local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local VectorUtil = require(ReplicatedStorage.SharedUtils.VectorUtil)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)

local HandleController = {}

local FORWARD_OFFSET = 1
local HANDLE_RADIUS = 1.5
local ARC_INNER_RADIUS_RATIO = .985
local HANDLE_RADIUS_TO_ARC_RATIO = .025

local camera = workspace.CurrentCamera
local previousHandleData: BuildClientService.HandleData?

@native
local function stepHandle(
    handleData: BuildClientService.HandleData, 
    buildData: BuildClientService.BuildData
)
    local cameraCFrame = camera.CFrame
    local cameraPosition = cameraCFrame.Position

    local handleModel = handleData.handleModel
    local handleModelScale = handleData.handleScale

    local buildModel = buildData.model
    local buildModelPivot = buildModel:GetPivot()
    local buildModelPosition = buildModelPivot.Position

    local toTargetDirection = (buildModelPosition - cameraPosition).Unit
    local initialHandleCFrame = CFrame.new(cameraPosition) + (toTargetDirection * FORWARD_OFFSET)
    local toTargetDistanceRatio = (
        (initialHandleCFrame.Position - cameraPosition).Magnitude
        / (buildModelPosition - cameraPosition).Magnitude
    )

    local newHandleCFrame = initialHandleCFrame:Lerp(buildModelPivot, toTargetDistanceRatio) * buildModelPivot.Rotation
    local newHandleScale = math.lerp(handleModelScale * toTargetDistanceRatio, handleModelScale, toTargetDistanceRatio)
    
    -- handle model
    do
        handleModel:PivotTo(newHandleCFrame)
        handleModel:ScaleTo(newHandleScale)
    end

    -- handle adornments
    do
        -- local originSize = handleModel.Origin.Size -- we're just relying on the transformed part prop itself
        -- local handleRadius = VectorUtil.Average3(originSize.X, originSize.Y, originSize.Z)/2
        local handleRadius = HANDLE_RADIUS * toTargetDistanceRatio

        for _, adornmentData in handleData.handleAdornmentDefaults do
            local adornmentAsset = adornmentData.asset
            local adornmentType = adornmentData.type

            -- rotate sphere handle
            if adornmentType == BuildClientService.HANDLE_ADORNMENT_TYPES.SphereHandleAdornment then
                adornmentAsset = (adornmentAsset:: SphereHandleAdornment)

                adornmentAsset.Radius = handleRadius

            -- arc handle
            elseif adornmentType == BuildClientService.HANDLE_ADORNMENT_TYPES.CylinderHandleAdornment then
                adornmentAsset = (adornmentAsset:: CylinderHandleAdornment)

                local handleModelSize = handleModel:GetExtentsSize()
                local handleModelRadius = (
                    VectorUtil.Average3(handleModelSize.X, handleModelSize.Y, handleModelSize.Z) 
                    - (
                        handleRadius
                        * 2 * (1 + (1 - ARC_INNER_RADIUS_RATIO))
                    )
                ) / 2
                
                adornmentAsset.InnerRadius = handleModelRadius * ARC_INNER_RADIUS_RATIO
                adornmentAsset.Radius = handleModelRadius
                adornmentAsset.Height = handleModelRadius * HANDLE_RADIUS_TO_ARC_RATIO
            end
        end
    end
end

local function resetHandle(handleData: BuildClientService.HandleData)
    handleData.handleModel:ScaleTo(1)
end

function HandleController.Init()
    Vide.effect(function()
        local handleData = BuildClientService.CurrentHandleData()

        if handleData then
            previousHandleData = handleData
        else
            resetHandle(previousHandleData:: BuildClientService.HandleData)
            previousHandleData = nil
        end
    end)

    RunService.RenderStepped:Connect(function()
        local handleData = BuildClientService.CurrentHandleData()
        local buildData = BuildClientService.CurrentBuildData()
        if 
            handleData == BuildClientService.NIL_HANDLE_DATA 
            or buildData == BuildClientService.NIL_BUILD_DATA
        then
            return
        end
        
        stepHandle(handleData, buildData)
    end)
end

return HandleController
