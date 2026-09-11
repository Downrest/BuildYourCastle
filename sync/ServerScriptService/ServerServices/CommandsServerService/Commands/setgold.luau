local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local CommandsServerService = require(ServerScriptService.ServerServices.CommandsServerService)
local DataServerService = require(ServerScriptService.ServerServices.DataServerService)
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
			warn("HEY IM GAY")
			DataServerService.SetPlayerDataAsync(player, function(data)
				return CurrencyServerService.IncrementGold(data, goldAmount) 
			end)
		end;
	})
end