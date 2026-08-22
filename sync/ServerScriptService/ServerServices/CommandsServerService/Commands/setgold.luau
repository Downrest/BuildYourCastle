local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CommandsServerService = require(ServerScriptService.ServerServices.CommandsServerService)
local CurrencyServerService = require(ServerScriptService.ServerServices.CurrencyServerService)
local Conch = require(ReplicatedStorage.SharedPackages.Conch)

return function()
	Conch.register(script.Name, {
		permissions = {CommandsServerService.PERMS.setgold};
		arguments = function()
			return
				Conch.args.player(), 
				Conch.args.number()
		end;
		callback = function(player, goldAmount)
			CurrencyServerService.SetGoldAsync(player, goldAmount)
		end;
	})
end