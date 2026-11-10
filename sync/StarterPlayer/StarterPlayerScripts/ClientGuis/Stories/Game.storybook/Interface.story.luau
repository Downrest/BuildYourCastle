local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local UILabs = require(ReplicatedStorage.SharedPackages.UILabs)
local InterfaceGui = require(StarterPlayer.StarterPlayerScripts.ClientGuis.InterfaceGui)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

return UILabs.CreateVideStory({
    controls = {
        IsVisible = UILabs.Boolean(true);
    };
    vide = Vide;
}, function(props)
    return InterfaceGui({
        IsVisible = props.controls.IsVisible;
        BuildPressed = Signal.new();
        CastlePressed = Signal.new();
        ShopPressed = Signal.new();
        HintPressed = Signal.new();
        VIPPressed = Signal.new();
        IndexPressed = Signal.new();
        GiftsPressed = Signal.new();
    })()
end)
