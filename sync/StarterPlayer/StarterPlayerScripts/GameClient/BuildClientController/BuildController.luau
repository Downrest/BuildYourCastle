local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
local BuildConfig = require(ReplicatedStorage.SharedConfigs.CastleConfig.BuildConfig)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
local VisualClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.VisualClientService)
local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local ModeController = require(script.ModeController)
local HandleController = require(script.HandleController)

local BuildController = {}

type HandleData = {
	instance: ConeHandleAdornment;
	direction: string;
}

local camera = workspace.CurrentCamera
local mountedBuildSelection: string? -- we just hydrate this state

local BUILD_RAY_PARAMS = RaycastParams.new(); do
	BUILD_RAY_PARAMS.FilterDescendantsInstances = { LocalPlayerUtil.character }
	BUILD_RAY_PARAMS.FilterType = Enum.RaycastFilterType.Exclude
end
local INIT_BUILD_RAY_DIST = 10

local function cacheBuildModel(buildName: string)
	local buildModel = BuildConfig.BUILD_TO_ASSET[buildName]:Clone()

	BuildClientService.BuildDataCache[buildName] = {
		model = buildModel;
		modelSize = buildModel:GetExtentsSize();
		adorneePart = (buildModel.PrimaryPart or buildModel:FindFirstChildWhichIsA("BasePart")) :: BasePart;
	}
end

local function getInitBuildCFrame(): CFrame
	local cameraCFrame = camera.CFrame
	local clampedCameraDirection = cameraCFrame.LookVector.Unit * INIT_BUILD_RAY_DIST
	local frontRay = workspace:Raycast(cameraCFrame.Position, clampedCameraDirection, BUILD_RAY_PARAMS)

	if frontRay then
		return CFrame.new(frontRay.Position)
	end
	return CFrame.new(cameraCFrame.Position + clampedCameraDirection)
end

local function mountBuild()
	mountedBuildSelection = BuildGuiService.CurrentBuildSelection()
	if mountedBuildSelection == "" then
		return
	end

	local buildData = BuildClientService.BuildDataCache[mountedBuildSelection]
	local buildModel = buildData.model

	buildModel:PivotTo(getInitBuildCFrame())

	BuildClientService.CurrentBuildData(buildData)
	VisualClientService.RegisterVisual(buildModel)
end

local function dismountBuild()
	if not mountedBuildSelection then
		return
	end

	local buildData = BuildClientService.BuildDataCache[mountedBuildSelection]
	if buildData then
		VisualClientService.UnregisterVisual(buildData.model)
	end

	mountedBuildSelection = nil
	BuildClientService.CurrentBuildData(BuildClientService.NIL_BUILD_DATA)
end

function BuildController.Init()
	for buildName in BuildConfig.BUILD_NAMES :: { [string]: string } do
		cacheBuildModel(buildName)
	end

	do
		HandleController.Init()
		ModeController.Init()
	end

	Vide.effect(function()
		dismountBuild()

        if BuildGuiService.IsVisible() then
			mountBuild()
        end
    end)
end

return BuildController
