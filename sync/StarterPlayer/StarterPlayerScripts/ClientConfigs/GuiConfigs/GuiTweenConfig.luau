local GuiTweenConfig = {}

GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_SLOW_TWEEN_INFO = TweenInfo.new(
    2.5,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.InOut
)
GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_SLOW_TWEEN_INFO = TweenInfo.new(
    2.5,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

GuiTweenConfig.INTERFACE_CONTAINER_FOCUS_TWEEN_INFO = TweenInfo.new(
    .5,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.InOut
)
GuiTweenConfig.INTERFACE_CONTAINER_DEFOCUS_TWEEN_INFO = TweenInfo.new(
    .5,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

GuiTweenConfig.INTERFACE_BUTTON_FOCUS_TWEEN_INFO = TweenInfo.new(
    .15,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.InOut
)
GuiTweenConfig.INTERFACE_BUTTON_DEFOCUS_TWEEN_INFO = TweenInfo.new(
    .25,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
)

GuiTweenConfig.MENU_FOCUS_TWEEN_INFO = TweenInfo.new(
    .2,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.InOut
)
GuiTweenConfig.MENU_DEFOCUS_TWEEN_INFO = TweenInfo.new(
    .2,
    Enum.EasingStyle.Quart,
    Enum.EasingDirection.Out
)

return GuiTweenConfig
