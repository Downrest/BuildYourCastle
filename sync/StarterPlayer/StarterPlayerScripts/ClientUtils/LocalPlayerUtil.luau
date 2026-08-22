local Players = game:GetService("Players")

local LocalPlayerUtil = {}

export type CharacterData = {
	character: Model;
	humanoid: Humanoid;
	animator: Animator;
}

type CharacterAddedCallbacks = {(playerData: CharacterData) -> ()}

local characterAddedCallbacks = {}:: CharacterAddedCallbacks

local function updateCharacterData(character: Model)
	LocalPlayerUtil.character = character
	LocalPlayerUtil.humanoid = character:WaitForChild("Humanoid"):: Humanoid
	LocalPlayerUtil.animator = LocalPlayerUtil.humanoid:WaitForChild("Animator"):: Animator
end

local function reflectCharacterData(): CharacterData
	return {
		character = LocalPlayerUtil.character;
		humanoid = LocalPlayerUtil.humanoid;
		animator = LocalPlayerUtil.animator;
	}
end

local function runCharacterAddedCallbacks(newCharacterData: CharacterData)
	for _, callback in characterAddedCallbacks do
		callback(newCharacterData)
	end
end

LocalPlayerUtil.player = Players.LocalPlayer
LocalPlayerUtil.playerGui = LocalPlayerUtil.player.PlayerGui

LocalPlayerUtil.character = LocalPlayerUtil.player.Character or LocalPlayerUtil.player.CharacterAdded:Wait()
LocalPlayerUtil.humanoid = LocalPlayerUtil.character:WaitForChild("Humanoid"):: Humanoid
LocalPlayerUtil.animator = LocalPlayerUtil.humanoid:WaitForChild("Animator"):: Animator

function LocalPlayerUtil.OnCharacter(callback: (characterData: CharacterData) -> ())
	table.insert(characterAddedCallbacks, callback)
	callback(reflectCharacterData())

	return {
		Disconnect = function()
			table.remove(characterAddedCallbacks, table.find(characterAddedCallbacks, callback))
		end
	}
end

-- init
do
	LocalPlayerUtil.player.CharacterAdded:Connect(function(character)
		updateCharacterData(character)
		runCharacterAddedCallbacks(reflectCharacterData())
	end)
end

return LocalPlayerUtil