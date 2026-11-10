local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.SharedPackages.Signal)
local Vide = require(ReplicatedStorage.SharedPackages.Vide)

local InterfaceGuiService = {}

export type InterfaceGui = typeof(InterfaceGuiService.INTERFACE_GUI)
export type InterfaceProps = {
    IsVisible: Vide.source<boolean>;

    BuildPressed: Signal.Signal;
    CastlePressed: Signal.Signal;
    ShopPressed: Signal.Signal;
    HintPressed: Signal.Signal;
    VIPPressed: Signal.Signal;
    IndexPressed: Signal.Signal;
    GiftsPressed: Signal.Signal;
}

InterfaceGuiService.INTERFACE_GUI = ReplicatedStorage.ClientAssets.Gui.Interface

InterfaceGuiService.IsVisible = Vide.source(true)
InterfaceGuiService.BuildPressed = Signal.new()
InterfaceGuiService.CastlePressed = Signal.new()
InterfaceGuiService.ShopPressed = Signal.new()
InterfaceGuiService.HintPressed = Signal.new()
InterfaceGuiService.VIPPressed = Signal.new()
InterfaceGuiService.IndexPressed = Signal.new()
InterfaceGuiService.GiftsPressed = Signal.new()

return InterfaceGuiService
