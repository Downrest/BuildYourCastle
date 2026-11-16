local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetSharedService = {}

local sharedAssets = ReplicatedStorage.SharedAssets

local clientAssets = ReplicatedStorage.ClientAssets
local buildAssets = clientAssets.BuildAssets

AssetSharedService.BUILD_ASSETS = sharedAssets.Build
AssetSharedService.CASTLE_ASSETS = sharedAssets.Castle

AssetSharedService.CLIENT_GUI_ASSETS = clientAssets.Gui --TODO: change CLIENT_GUI_ASSETS to GUI_ASSETS, or no really just change this lol
AssetSharedService.BUILD_MOVE_HANDLE_ASSETS = buildAssets.HandleAssets

return AssetSharedService
