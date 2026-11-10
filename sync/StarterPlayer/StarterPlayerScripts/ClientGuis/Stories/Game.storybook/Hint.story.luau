local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local HintGui = require(StarterPlayer.StarterPlayerScripts.ClientGuis.HintGui)
local UILabs = require(ReplicatedStorage.SharedPackages.UILabs)
local HintGuiService = require(StarterPlayer.StarterPlayerScripts.ClientServices.GuiServices.HintGuiService)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

return UILabs.CreateVideStory({
    controls = {
        CurrentHint = UILabs.Choose({
            HintGuiService.HINTS.CannotBuild,
            HintGuiService.HINTS.FirstFloorReached,
            ""
        });
    };
    vide = Vide;
}, function(props)
    return HintGui({
        CurrentHint = props.controls.CurrentHint;
    })()
end)
