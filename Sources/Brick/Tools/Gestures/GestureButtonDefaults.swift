//
//  GestureButtonDefaults.swift
//
//  Created by iOS on 2023/6/28.
//
//

import Foundation

/// This struct is used to configure gesture button defaults.
@MainActor
public struct GestureButtonDefaults {

    /// The max time between two taps to count as a double tap, by default `0.2`.
    public static var doubleTapTimeout = 0.2

    /// The time it takes for a press to count as a long press, by default `1.0`.
    public static var longPressDelay = 1.0

    /// The time it takes for a press to count as a repeat trigger, by default `1.0`.
    public static var repeatDelay = 1.0
}
