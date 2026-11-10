local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetSharedService = {}

local sharedAssets = ReplicatedStorage.SharedAssets
local buildAssets = sharedAssets.Build
local castleAssets = sharedAssets.Castle

AssetSharedService.BuildAssets = buildAssets
AssetSharedService.CastleAssets = castleAssets

return AssetSharedService
