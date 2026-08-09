local RunService = game:GetService("RunService")

local speed = 0.1

local progress = 0

RunService.RenderStepped:Connect(function(deltaTime)
	progress += deltaTime * speed
	
	for i, v in script.Parent:GetChildren() do
		if v:IsA("GuiLabel") then
			v.AnchorPoint = Vector2.new(0.5, 0.5)
			v.Position = UDim2.new(((-progress+ 0.2*i) % 1) * 1.2 - 0.1, 0, 0.5, 0)
		end
	end
end)
