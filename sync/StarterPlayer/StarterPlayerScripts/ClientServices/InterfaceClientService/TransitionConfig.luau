local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.InterfaceConfig)

local TransitionConfig = {}

TransitionConfig.TRANSITIONS = {
    [InterfaceConfig.GUIS.Interface] = {
        enter = {
            InterfaceConfig.GUIS.Build;
        };
        exit = {
            InterfaceConfig.GUIS.Nil;
        };
    };

    [InterfaceConfig.GUIS.Build] = {
        enter = {
            InterfaceConfig.GUIS.Interface;
        };
        exit = {
            InterfaceConfig.GUIS.Interface;
        };
    };
}

return TransitionConfig
