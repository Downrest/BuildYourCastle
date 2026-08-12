local Players = game:GetService("Players")

local PlayerUtil = {}

export type CharacterData = {
	character: Model;
	humanoid: Humanoid;
	animator: Animator;
}

type CharacterAddedCallbacks = {(playerData: CharacterData) -> ()}

local characterAddedCallbacks = {}:: CharacterAddedCallbacks

local function updateCharacterData(character: Model)
	PlayerUtil.character = character
	PlayerUtil.humanoid = character:WaitForChild("Humanoid"):: Humanoid
	PlayerUtil.animator = PlayerUtil.humanoid:WaitForChild("Animator"):: Animator
end

local function reflectCharacterData(): CharacterData
	return {
		character = PlayerUtil.character;
		humanoid = PlayerUtil.humanoid;
		animator = PlayerUtil.animator;
	}
end

local function runCharacterAddedCallbacks(newCharacterData: CharacterData)
	for _, callback in characterAddedCallbacks do
		callback(newCharacterData)
	end
end

local function init()
	-- run `characterAddedCallbacks` when applicable 
	PlayerUtil.player.CharacterAdded:Connect(function(character)
		updateCharacterData(character)
		runCharacterAddedCallbacks(reflectCharacterData())
	end)
end

PlayerUtil.player = Players.LocalPlayer
PlayerUtil.playerGui = PlayerUtil.player.PlayerGui

PlayerUtil.character = PlayerUtil.player.Character or PlayerUtil.player.CharacterAdded:Wait()
PlayerUtil.humanoid = PlayerUtil.character:WaitForChild("Humanoid"):: Humanoid
PlayerUtil.animator = PlayerUtil.humanoid:WaitForChild("Animator"):: Animator

PlayerUtil.OnCharacter = function(callback: (characterData: CharacterData) -> ())
	table.insert(characterAddedCallbacks, callback)
	callback(reflectCharacterData())

	return {
		Disconnect = function()
			table.remove(characterAddedCallbacks, table.find(characterAddedCallbacks, callback))
		end
	}
end

init()

return PlayerUtil