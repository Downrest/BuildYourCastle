local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)

local CleanupUtil = {}

type Destroy = {Destroy: (...any) -> ()}
type Disconnect = {Disconnect: (...any) -> ()}
type Pause = {Pause: (...any) -> ()}
type Destructors = Destroy | Disconnect | Pause

export type Trash = 
	| (Instance & Destroy)
| (RBXScriptConnection & Disconnect)
| (Tween & Pause)
| (...any) -> (...any) -- assuming this to be a destructor function
| Signal.Connection<any> -- for NamedSignal implementation
| thread

| Destructors

local DESTRUCTORS = {"Destroy", "Disconnect", "Cancel"}

local function cleanup(trash: Trash)
	if not trash then
		return
	end

	local type = typeof(trash)

	if type == "function" then 
		(trash:: () -> ())()
	elseif type == "RBXScriptConnection" then
		(trash:: RBXScriptConnection):Disconnect()
	elseif type == "Instance" then
		if (trash:: Instance).ClassName == "Tween" then
			(trash:: Tween):Pause() -- pause, not cancel to avoid reverting back to "original position"
		end

		(trash:: Instance):Destroy()
	elseif type == "thread" then
		if coroutine.status((trash:: thread)) == "suspended" then
			task.cancel((trash:: thread))
		end
	else
		for _, destructor in DESTRUCTORS do
			trash = (trash:: Destructors)

			if trash[destructor] then
				trash[destructor](trash)
			end
		end
	end
end

function CleanupUtil.Clean(bin: {[any]: Trash}, ...: string)
	local specifiedIndicies = table.pack(...); do
		specifiedIndicies.n = (nil:: any)
	end

	-- for cleaning up specific trash with their specific indicies
	if #specifiedIndicies > 0 then
		for _, index in specifiedIndicies do
			cleanup(bin[index])
		end
	else
		for _, trash in (bin:: {Trash}) do
			cleanup(trash)
		end
		table.clear(bin)
	end

	return specifiedIndicies
end

function CleanupUtil.InsertBin<trash>(
	bin: {[any]: Trash},
	trash: trash,
	index: string?
): trash
	if index then
		bin[index] = trash
	else
		table.insert(bin, trash)
	end

	return trash
end

return CleanupUtil