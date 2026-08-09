local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Conch = require(ReplicatedStorage.SharedPackages.Conch)

local CommandsServerService = {}

CommandsServerService.PERMS = {
    setgold = "setgold";
}
CommandsServerService.ROLES = {
    Developer = "Developer";
}
CommandsServerService.PERMS_PER_ROLE = {
    [CommandsServerService.ROLES.Developer] = {
        CommandsServerService.PERMS.setgold;
    }
}
CommandsServerService.PLAYER_DEFAULTS = {
    -- downrest
    [1470601882] = {CommandsServerService.ROLES.Developer};
}

function CommandsServerService.Init()
    Conch.initiate_default_lifecycle()

    -- role perms
	do
        -- apply role + perms
		for roleName, permData in CommandsServerService.PERMS_PER_ROLE:: {[string]: {string}} do
            Conch.set_role_permissions(roleName, table.unpack(permData))
		end

        -- apply player defaults with their respective roles
        Players.PlayerAdded:Connect(function(player)
            local roleData = CommandsServerService.PLAYER_DEFAULTS[player.UserId]
            if not roleData then
                return
            end

            local conchUser = Conch.get_user(player)
            for _, role in roleData do
                Conch.give_roles(conchUser, role)
            end
        end)
	end

	-- commands
	do
		for _, commandModule in script.Commands:GetChildren() do
			(require(commandModule):: any)()
		end
	end
end

return CommandsServerService
