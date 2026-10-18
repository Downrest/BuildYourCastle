local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Vide = require(ReplicatedStorage.SharedPackages.Vide)
local LoaderUtil = require(ReplicatedStorage.SharedUtils.LoaderUtil)

-- top-level scope
Vide.root(function()
    -- SERVICES
    do
        -- shared
        LoaderUtil.Boot(ReplicatedStorage.SharedServices.DataSharedService)
        LoaderUtil.Boot(ReplicatedStorage.SharedServices.CastleSharedService)
        LoaderUtil.Boot(ReplicatedStorage.SharedServices.MapSharedService)
        LoaderUtil.Boot(ReplicatedStorage.SharedServices.NPCSharedService)

        -- client
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.ClientServices.DataClientService)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.ClientServices.BuildClientService)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.ClientServices.CastleClientService)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.ClientServices.LoadingClientService)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.ClientServices.TutorialClientService)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.ClientServices.InterfaceClientService)
    end

    -- CONTROLLERS
    do
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.BuildClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.CastleClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.CommandsClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.CurrencyClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.GiftsClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.IndexClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.InterfaceClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.NextHintClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.RebirthClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.ShopClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.TutorialClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.VIPClientController)
        LoaderUtil.Boot(StarterPlayer.StarterPlayerScripts.GameClient.HintClientController)
    end
end)
