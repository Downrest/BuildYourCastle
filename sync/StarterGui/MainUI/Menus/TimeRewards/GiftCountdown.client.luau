--!strict
--=========================================================
-- GIFT COUNTDOWN TIMER - EASILY EDITABLE
--=========================================================
-- This script manages the countdown for the TimeRewards
-- (Free Gifts) menu. Edit the CONFIG section below.
--=========================================================

--=========================================================
-- CONFIG - EDIT THESE VALUES
--=========================================================

-- How long between gift claims, in SECONDS.
-- Examples: 60 = 1 min | 3600 = 1 hour | 86400 = 1 day
local COOLDOWN_SECONDS = 3600

-- Text shown above the countdown while waiting.
local COUNTDOWN_PREFIX = "Next Gift: "

-- Text shown when the gift is ready to claim.
local READY_TEXT = "Gift Ready!"

-- Text color when the gift is ready (RGB 0-1).
local READY_COLOR = Color3.fromRGB(85, 255, 127)

-- Text color while counting down (RGB 0-1).
local WAITING_COLOR = Color3.fromRGB(255, 255, 255)

--=========================================================
-- END CONFIG - You generally don't need to edit below
--=========================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Find the TimeRewards frame (it may be cloned to PlayerGui)
local function getTimeRewardsFrame()
	local playerGui = player:WaitForChild("PlayerGui")
	local mainUI = playerGui:FindFirstChild("MainUI")
	if not mainUI then return nil end
	local menus = mainUI:FindFirstChild("Menus")
	if not menus then return nil end
	return menus:FindFirstChild("TimeRewards (done)")
end

local timeRewards = getTimeRewardsFrame()
if not timeRewards then
	warn("[GiftCountdown] Could not find TimeRewards frame")
	return
end

local countdownLabel = timeRewards:FindFirstChild("CountdownLabel")
if not countdownLabel then
	warn("[GiftCountdown] Could not find CountdownLabel")
	return
end

--=========================================================
-- TIMER LOGIC
--=========================================================

-- nextClaimTime is when the next gift becomes available.
-- On first load, the gift is immediately available.
local nextClaimTime = tick() -- available right away

-- Format seconds into HH:MM:SS
local function formatTime(seconds)
	if seconds < 0 then seconds = 0 end
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = math.floor(seconds % 60)
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- Reset the countdown (called when a gift is claimed)
local function startCooldown()
	nextClaimTime = tick() + COOLDOWN_SECONDS
end

--=========================================================
-- GIFT CLAIMING
--=========================================================

-- Find all Claim buttons inside the TimeRewards frame
local function getClaimButtons()
	local buttons = {}
	for _, descendant in ipairs(timeRewards:GetDescendants()) do
		if descendant:IsA("GuiButton") and descendant.Name == "Claim" then
			table.insert(buttons, descendant)
		end
	end
	return buttons
end

-- Update claim button appearance based on readiness
local function updateClaimButtons(isReady)
	for _, btn in ipairs(getClaimButtons()) do
		if isReady then
			btn.ImageColor3 = Color3.fromRGB(255, 255, 255)
			btn.AutoButtonColor = true
		else
			btn.ImageColor3 = Color3.fromRGB(100, 100, 100)
			btn.AutoButtonColor = false
		end
	end
end

-- Connect claim buttons
local claimed = false
for _, btn in ipairs(getClaimButtons()) do
	btn.MouseButton1Click:Connect(function()
		if tick() >= nextClaimTime and not claimed then
			claimed = true
			startCooldown()
			claimed = false
			-- TODO: Add your reward logic here
			-- e.g.: give coins, items, etc.
			print("[GiftCountdown] Gift claimed! Next gift in " .. COOLDOWN_SECONDS .. " seconds.")
		end
	end)
end

--=========================================================
-- COUNTDOWN LOOP
--=========================================================

while true do
	local remaining = nextClaimTime - tick()

	if remaining <= 0 then
		countdownLabel.Text = READY_TEXT
		countdownLabel.TextColor3 = READY_COLOR
		updateClaimButtons(true)
	else
		countdownLabel.Text = COUNTDOWN_PREFIX .. formatTime(remaining)
		countdownLabel.TextColor3 = WAITING_COLOR
		updateClaimButtons(false)
	end

	task.wait(0.5)
end
