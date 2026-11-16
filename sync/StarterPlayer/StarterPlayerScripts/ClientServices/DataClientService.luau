local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local LocalPlayerUtil = require(StarterPlayer.StarterPlayerScripts.ClientUtils.LocalPlayerUtil)
local DataSharedService = require(ReplicatedStorage.SharedServices.DataSharedService)

local DataClientService = {}

DataClientService.PlayerState = DataSharedService.PlayerStream:Replica(LocalPlayerUtil.player)

return DataClientService