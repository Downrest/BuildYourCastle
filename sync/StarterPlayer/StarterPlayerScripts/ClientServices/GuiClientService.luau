local GuiClientService = {}

GuiClientService.INTERFACE_BUTTON_FOCUS_TWEEN_INFO = TweenInfo.new(
    .15,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.InOut
)
GuiClientService.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO = TweenInfo.new(
    .25,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)

GuiClientService.MENU_FOCUS_TWEEN_INFO = TweenInfo.new(
    .2,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.InOut
)
GuiClientService.MENU_DEFOCUS_TWEEN_INFO = TweenInfo.new(
    .2,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

return GuiClientService
