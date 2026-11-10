local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local BuildGui = require(StarterPlayer.StarterPlayerScripts.ClientGuis.BuildGui)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local UILabs = require(ReplicatedStorage.SharedPackages.UILabs)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

return UILabs.CreateVideStory({
    controls = {
        IsVisible = UILabs.Boolean(true);
    };
    vide = Vide;
}, function(props)
    return BuildGui({
        IsVisible = props.controls.IsVisible;
        CurrentMode = Vide.source("");
        CurrentCategory = Vide.source("");
        CurrentBuildSelection = Vide.source("");
        
        ExitPressed = Signal.new();
    })()
end)
