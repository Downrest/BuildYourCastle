local StarterPlayer = game:GetService("StarterPlayer")

local InterfaceConfig = require(StarterPlayer.StarterPlayerScripts.ClientConfigs.InterfaceConfig)

local GUIS = InterfaceConfig.GUIS

return {
    [GUIS.Interface] = {
        enter = {};
        exit = {
            GUIS.Nil;
        };
    };

    [GUIS.Build] = {
        enter = {
            GUIS.Interface;
        };
        exit = {
            GUIS.Interface;
        };
    };
}
