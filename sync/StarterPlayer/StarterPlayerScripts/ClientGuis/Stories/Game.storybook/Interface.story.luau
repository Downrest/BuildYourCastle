local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local UILabs = require(ReplicatedStorage.SharedPackages.UILabs)
local InterfaceGui = require(StarterPlayer.StarterPlayerScripts.ClientGuis.InterfaceGui)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

return UILabs.CreateVideStory({
    controls = {
        IsVisible = true;

        CurrentGold = 0;
        PreviousGold = 0;
    };
    vide = Vide;
}, function(props)
    return InterfaceGui({

        IsVisible = props.controls.IsVisible;
        CurrentGold = props.controls.CurrentGold;
        PreviousGold = props.controls.PreviousGold;

        BuildPressed = Signal.new();
        CastlePressed = Signal.new();
        ShopPressed = Signal.new();
        HintPressed = Signal.new();
        VIPPressed = Signal.new();
        IndexPressed = Signal.new();
        GiftsPressed = Signal.new();
    })()
end)
