local GuiConfig = {}

GuiConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO = TweenInfo.new(
    1,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.InOut
)
GuiConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO = TweenInfo.new(
    1,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

GuiConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO = TweenInfo.new(
    .15,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.InOut
)
GuiConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO = TweenInfo.new(
    .25,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)

GuiConfig.MENU_FOCUS_TWEEN_INFO = TweenInfo.new(
    .2,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.InOut
)
GuiConfig.MENU_DEFOCUS_TWEEN_INFO = TweenInfo.new(
    .2,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

return GuiConfig
