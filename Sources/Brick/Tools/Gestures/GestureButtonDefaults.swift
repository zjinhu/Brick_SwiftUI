//
//  GestureButtonDefaults.swift
//
//  Created by iOS on 2023/6/28.
//
//

import Foundation

/// 手势按钮默认值配置/Gesture button defaults configuration
/// 用于配置手势按钮的默认参数值。/This struct is used to configure gesture button defaults.
@MainActor
public struct GestureButtonDefaults {

    /// 两次点击被视为双击的最大时间间隔，默认值为0.2/The max time between two taps to count as a double tap, by default `0.2`.
    public static var doubleTapTimeout = 0.2

    /// 按压被视为长按所需的时间，默认值为1.0/The time it takes for a press to count as a long press, by default `1.0`.
    public static var longPressDelay = 1.0

    /// 按压被视为重复触发所需的时间，默认值为1.0/The time it takes for a press to count as a repeat trigger, by default `1.0`.
    public static var repeatDelay = 1.0
}
