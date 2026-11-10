-- based on https://devforum.roblox.com/t/camerazoomtoextents/1514600/5

local ViewportUtil = {}

local DEFAULT_FORWARD_OFFSET = 0
local DEFAULT_ORIENTATION = CFrame.new()

export type ViewportConfig = {
	forwardOffset: number?;
	orientation: CFrame?;
}

local function getSize(instance: Instance): Vector3
    if instance:IsA("BasePart") then
        return instance.Size
    elseif instance:IsA("Model") then
        local _, size = instance:GetBoundingBox()
        return size
    end
    return Vector3.zero
end

function ViewportUtil.config(config: ViewportConfig)
	local self = {}

	function self.FitCFrame(
		camera: Camera, 
		viewport: ViewportFrame, 
		instanceToFit: Instance
	): CFrame
		return ViewportUtil.FitCFrame(
			camera,
			viewport,
			instanceToFit,
			config
		)
	end

	return self
end

function ViewportUtil.FitCFrame(
    camera: Camera, 
    viewport: ViewportFrame, 
    instanceToFit: Instance, 
    config: ViewportConfig?
)
	config = config or {}:: ViewportConfig

	local cameraCFrame = camera.CFrame
	local viewportSize = viewport.AbsoluteSize
	local instanceRadius = getSize(instanceToFit).Magnitude / 2
	local cameraFOV; do
		local widthHeightRatio = math.min(1, viewportSize.X / viewportSize.Y)
		local yFOV2 = math.rad(camera.FieldOfView / 2)
		local xFOV2 = math.atan(math.tan(yFOV2) * widthHeightRatio)

		cameraFOV = xFOV2
	end
	local fitOffset = instanceRadius / math.sin(cameraFOV)

	return CFrame.lookAt(
		cameraCFrame.Position + (cameraCFrame.LookVector * (fitOffset + -(config.forwardOffset or DEFAULT_FORWARD_OFFSET))),
		cameraCFrame.Position
	) * (config.orientation or DEFAULT_ORIENTATION)
end

return ViewportUtil
