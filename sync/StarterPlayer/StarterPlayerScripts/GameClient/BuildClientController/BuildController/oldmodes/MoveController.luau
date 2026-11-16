-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local StarterPlayer = game:GetService("StarterPlayer")

-- local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
-- local BuildGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.BuildGuiService)
-- local Vide = require(ReplicatedStorage.SharedPackages.Vide)
-- local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
-- local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)

local MoveController = {}

-- local moveHandleAssets = AssetSharedService.BUILD_MOVE_HANDLE_ASSETS
-- local bin = Janitor.new()

-- local MOVE_DIRECTIONS = {
-- 	Up = "Up";
-- 	Down = "Down";
-- 	Front = "Front";
-- 	Back = "Back";
-- 	Left = "Left";
-- 	Right = "Right";
-- }
-- local MOVE_DIRECTION_AXIS = {
-- 	[MOVE_DIRECTIONS.Up] = Vector3.yAxis;
-- 	[MOVE_DIRECTIONS.Down] = -Vector3.yAxis;
-- 	[MOVE_DIRECTIONS.Front] = Vector3.zAxis;
-- 	[MOVE_DIRECTIONS.Back] = -Vector3.zAxis;
-- 	[MOVE_DIRECTIONS.Left] = -Vector3.xAxis;
-- 	[MOVE_DIRECTIONS.Right] = Vector3.xAxis;
-- }
-- local MOVE_HANDLES = {
--     [MOVE_DIRECTIONS.Up] = moveHandleAssets.UpHandle:Clone();
--     [MOVE_DIRECTIONS.Down] = moveHandleAssets.DownHandle:Clone();
--     [MOVE_DIRECTIONS.Front] = moveHandleAssets.FrontHandle:Clone();
--     [MOVE_DIRECTIONS.Back] = moveHandleAssets.BackHandle:Clone();
--     [MOVE_DIRECTIONS.Left] = moveHandleAssets.LeftHandle:Clone();
--     [MOVE_DIRECTIONS.Right] = moveHandleAssets.RightHandle:Clone();
-- }; do
--     for _, moveHandle in MOVE_HANDLES do
--         moveHandle.Parent = LocalPlayerUtil.playerGui
--     end
-- end

-- local function mountMove()
--     for direction, handle in MOVE_HANDLES do
--         local axis = MOVE_DIRECTION_AXIS[direction]

--         bin:Add(handle.MouseButton1Down:Connect(function()
--             warn(`pressed {handle}`)
--         end))
--         bin:Add(handle.MouseButton1Up:Connect(function()
--             warn(`released {handle}`)
--         end))
--     end
-- end

-- local function dismountMove()
--     bin:Cleanup()
-- end

function MoveController.Init()
	-- Vide.effect(function()
    --     if BuildGuiService.CurrentMode() == BuildGuiService.BUTTON_SELECTIONS.Select then
    --         mountMove()
    --     else
    --         dismountMove()
    --     end
	-- end)
end


return MoveController
