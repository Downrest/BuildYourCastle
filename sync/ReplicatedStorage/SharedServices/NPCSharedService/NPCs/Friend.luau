local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NPCEnums = require(ReplicatedStorage.SharedServices.NPCSharedService.NPCEnums)

return {
	name = NPCEnums.NPC_NAMES.Friend;
	popularityToSpawn = 0;
	goldToGive = 250;
}