local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")

local BuildConfig = require(ReplicatedStorage.SharedConfigs.CastleConfig.BuildConfig)
local Janitor = require(ReplicatedStorage.SharedPackages.Janitor)

local bin = Janitor.new()
local subbin = Janitor.new()

bin:Add(subbin)
bin:Cleanup()