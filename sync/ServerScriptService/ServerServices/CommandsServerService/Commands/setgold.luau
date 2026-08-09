local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CommandsServerService = require(ServerScriptService.ServerServices.CommandsServerService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)
local Conch = require(ReplicatedStorage.SharedPackages.Conch)

return function()
	warn("hello?")
	Conch.register(script.Name, {
		permissions = {CommandsServerService.PERMS.setgold};
		arguments = function()
			return
				Conch.args.player(), 
				Conch.args.number()
		end;
		callback = function(player, goldAmount)
			DataServerService.SetGold(player, goldAmount)
		end;
	})
end