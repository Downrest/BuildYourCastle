local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetSharedService = require(ReplicatedStorage.SharedServices.AssetSharedService)
local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local InterfaceGuiService = {}

export type InterfaceGui = typeof(InterfaceGuiService.INTERFACE_GUI)
export type InterfaceProps = {
    IsVisible: Vide.source<boolean>;

    CurrentGold: Vide.source<number>;
    PreviousGold: Vide.source<number>;

    BuildPressed: Signal.Signal;
    CastlePressed: Signal.Signal;
    ShopPressed: Signal.Signal;
    HintPressed: Signal.Signal;
    VIPPressed: Signal.Signal;
    IndexPressed: Signal.Signal;
    GiftsPressed: Signal.Signal;
}

InterfaceGuiService.INTERFACE_GUI = AssetSharedService.CLIENT_GUI_ASSETS.Interface

InterfaceGuiService.IsVisible = Vide.source(true)

InterfaceGuiService.CurrentGold = Vide.source(0)
InterfaceGuiService.PreviousGold = Vide.source(0)

InterfaceGuiService.BuildPressed = Signal.new()
InterfaceGuiService.CastlePressed = Signal.new()
InterfaceGuiService.ShopPressed = Signal.new()
InterfaceGuiService.HintPressed = Signal.new()
InterfaceGuiService.VIPPressed = Signal.new()
InterfaceGuiService.IndexPressed = Signal.new()
InterfaceGuiService.GiftsPressed = Signal.new()

return InterfaceGuiService
