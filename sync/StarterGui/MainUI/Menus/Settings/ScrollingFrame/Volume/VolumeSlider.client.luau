local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- UI references
local volumeFrame = script.Parent
local track = volumeFrame:FindFirstChild("Track")
local fill = track and track:FindFirstChild("Fill")
local handle = track and track:FindFirstChild("Handle")
local valueLabel = volumeFrame:FindFirstChild("ValueLabel")

if not track or not fill or not handle or not valueLabel then
	warn("[VolumeSlider] Could not find slider UI elements")
	return
end

-- Default volume (0 to 1)
local DEFAULT_VOLUME = 0.5
local currentVolume = player:GetAttribute("MusicVolume")
if type(currentVolume) ~= "number" then
	currentVolume = DEFAULT_VOLUME
end

-- Find the BackgroundMusic sound created by MusicToggle script
local function getMusicSound()
	return SoundService:FindFirstChild("BackgroundMusic")
end

-- Update the visual slider position and the music volume
local function updateSlider(volume)
	volume = math.clamp(volume, 0, 1)
	currentVolume = volume

	-- Update visuals
	fill.Size = UDim2.new(volume, 0, 1, 0)
	handle.Position = UDim2.new(volume, 0, 0.5, 0)
	valueLabel.Text = string.format("%d%%", math.floor(volume * 100 + 0.5))

	-- Update the actual sound volume
	local musicSound = getMusicSound()
	if musicSound then
		musicSound.Volume = volume
	end

	-- Persist the volume setting
	player:SetAttribute("MusicVolume", volume)
end

-- Set initial slider state
updateSlider(currentVolume)

-- === Dragging logic ===
local dragging = false

local function getVolumeFromMouse()
	-- Calculate the mouse position relative to the track
	local trackPos = track.AbsolutePosition
	local trackSize = track.AbsoluteSize
	local mousePos = UserInputService:GetMouseLocation()

	-- mousePos is in screen space (top-left origin), trackPos is also screen space
	local relativeX = (mousePos.X - trackPos.X) / trackSize.X
	return math.clamp(relativeX, 0, 1)
end

-- Handle dragging the knob
handle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
	end
end)

handle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- Click on track to jump to position
track.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		updateSlider(getVolumeFromMouse())
	end
end)

track.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- Update while dragging
UserInputService.InputChanged:Connect(function(input)
	if not dragging then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		updateSlider(getVolumeFromMouse())
	end
end)

-- Poll for the music sound in case it hasn't been created yet
-- (MusicToggle creates it when the script runs, which may be after this script)
task.spawn(function()
	local attempts = 0
	while attempts < 50 do
		local musicSound = getMusicSound()
		if musicSound then
			musicSound.Volume = currentVolume
			break
		end
		attempts += 1
		task.wait(0.1)
	end
end)