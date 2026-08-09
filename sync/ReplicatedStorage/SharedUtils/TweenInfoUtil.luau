local TweenInfoUtil = {}

export type TweenInfoOverrides = {
    Time: number?,
    EasingStyle: Enum.EasingStyle?,
    EasingDirection: Enum.EasingDirection?,
    RepeatCount: number?,
    Reverses: boolean?,
    DelayTime: number?,
}

function TweenInfoUtil.Override(overrides: TweenInfoOverrides, tweenInfo: TweenInfo): TweenInfo
    return TweenInfo.new(
        overrides.Time and overrides.Time or tweenInfo.Time,
        overrides.EasingStyle and overrides.EasingStyle or tweenInfo.EasingStyle,
        overrides.EasingDirection and overrides.EasingDirection or tweenInfo.EasingDirection,
        overrides.RepeatCount and overrides.RepeatCount or tweenInfo.RepeatCount,
        overrides.Reverses ~= nil and overrides.Reverses or tweenInfo.Reverses,
        overrides.DelayTime and overrides.DelayTime or tweenInfo.DelayTime
    )
end

function TweenInfoUtil.OverrideTime(time: number, tweenInfo: TweenInfo): TweenInfo
    return TweenInfoUtil.Override(
        {
            Time = time
        },
        tweenInfo
    )
end

function TweenInfoUtil.IncrementTime(timeIncrement: number, tweenInfo: TweenInfo): TweenInfo
    return TweenInfoUtil.Override(
        {
            Time = tweenInfo.Time + timeIncrement
        },
        tweenInfo
    )
end

function TweenInfoUtil.OverrideEasingStyle(easingStyle: Enum.EasingStyle, tweenInfo: TweenInfo): TweenInfo
    return TweenInfoUtil.Override(
        {
            EasingStyle = easingStyle
        },
        tweenInfo
    )
end

function TweenInfoUtil.OverrideEasingDirection(easingDirection: Enum.EasingDirection, tweenInfo: TweenInfo): TweenInfo
    return TweenInfoUtil.Override(
        {
            EasingDirection = easingDirection
        },
        tweenInfo
    )
end

function TweenInfoUtil.OverrideRepeatCount(repeatCount: number, tweenInfo: TweenInfo): TweenInfo
    return TweenInfoUtil.Override(
        {
            RepeatCount = repeatCount
        },
        tweenInfo
    )
end

function TweenInfoUtil.OverrideReverses(reverses: boolean, tweenInfo: TweenInfo): TweenInfo
    return TweenInfoUtil.Override(
        {
            Reverses = reverses
        },
        tweenInfo
    )
end

function TweenInfoUtil.OverrideDelayTime(delayTime: number, tweenInfo: TweenInfo): TweenInfo
    return TweenInfoUtil.Override(
        {
            DelayTime = delayTime
        },
        tweenInfo
    )
end

return TweenInfoUtil