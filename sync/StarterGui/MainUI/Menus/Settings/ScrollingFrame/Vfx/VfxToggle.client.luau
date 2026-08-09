local Players = game:GetService("Players")

local player = Players.LocalPlayer

local vfxFrame = script.Parent
local onButton = vfxFrame:FindFirstChild("On")
local offButton = vfxFrame:FindFirstChild("Off")

if not onButton or not offButton then
	warn("[VfxToggle] Could not find On/Off buttons")
	return
end

-- Default: VFX is ON
player:SetAttribute("VfxEnabled", true)

local function setVfxEnabled(isEnabled)
	player:SetAttribute("VfxEnabled", isEnabled)

	if isEnabled then
		onButton.Visible = true
		offButton.Visible = false
	else
		onButton.Visible = false
		offButton.Visible = true
	end
end

onButton.MouseButton1Click:Connect(function()
	setVfxEnabled(false)
end)

offButton.MouseButton1Click:Connect(function()
	setVfxEnabled(true)
end)