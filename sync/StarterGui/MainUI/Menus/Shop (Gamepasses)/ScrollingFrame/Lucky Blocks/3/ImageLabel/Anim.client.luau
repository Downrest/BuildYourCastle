local RunService = game:GetService("RunService")

local image = script.Parent

local originalPos = image.Position

local progress = 0
RunService.RenderStepped:Connect(function(dt)
	progress += dt
	image.Rotation = math.sin(progress * 1.4) * 5
	
	image.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset, originalPos.Y.Scale + math.sin(progress * 3) * 0.01, originalPos.Y.Offset)
end)