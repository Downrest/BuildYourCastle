--[[


The mirror will only work when ingame (or test mode), due to its scripted nature.


]]

local mirror = script.Mirror

mirror.Adornee = script.Parent

mirror:Clone().Parent = game.StarterGui