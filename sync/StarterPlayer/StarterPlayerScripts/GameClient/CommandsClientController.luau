local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Conch = require(ReplicatedStorage.SharedPackages.Conch)
local ConchUI = require(ReplicatedStorage.SharedPackages.ConchUI)

local CommandsClientController = {}

function CommandsClientController.Init()
    Conch.initiate_default_lifecycle()
    ConchUI.bind_to(Enum.KeyCode.Q)
end

return CommandsClientController
