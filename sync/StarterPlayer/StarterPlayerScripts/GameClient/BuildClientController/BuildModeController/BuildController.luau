local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local BuildClientService = require(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)

local BuildController = {}

local buildBin = Janitor.new()

function BuildController.Mount()
    buildBin:Add(Vide.root(function()
        Vide.effect(function()
            BuildClientService.CurrentButtonSelection()
        end)
    end))
end

function BuildController.Dismount()
    buildBin:Cleanup()
end

return BuildController