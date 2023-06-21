//
//  TabbarEnvironmentKey.swift
//  Example
//
//  Created by iOS on 2023/6/21.
//

import SwiftUI
 
struct TabBarForegroundViewEnviromentKey: EnvironmentKey {
    static var defaultValue: (() -> AnyView)? { nil }
}

extension EnvironmentValues {
    var tabBarForegroundView: (() -> AnyView)? {
        get { self[TabBarForegroundViewEnviromentKey.self] }
        set { self[TabBarForegroundViewEnviromentKey.self] = newValue }
    }
}

struct TabBarShapeEnvironmentKey: EnvironmentKey {
    static var defaultValue: (any Shape)? = nil
}

extension EnvironmentValues {
    var tabBarShape: (any Shape)? {
        get { self[TabBarShapeEnvironmentKey.self] }
        set { self[TabBarShapeEnvironmentKey.self] = newValue }
    }
}
 
struct TabBarColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color? = nil
}

extension EnvironmentValues {
    var tabBarColor: Color? {
        get { self[TabBarColorEnvironmentKey.self] }
        set { self[TabBarColorEnvironmentKey.self] = newValue }
    }
}

struct TabBarShadowEnvironmentKey: EnvironmentKey {
    static var defaultValue: Shadow = .init(color: .black.opacity(0.33), radius: 5, x: 0, y: 5)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat

    init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

extension EnvironmentValues {
    var tabBarShadow: Shadow {
        get { self[TabBarShadowEnvironmentKey.self] }
        set { self[TabBarShadowEnvironmentKey.self] = newValue }
    }
}

struct InPaddingEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 5
}

extension EnvironmentValues {
    var tabBarInPadding: CGFloat {
        get { self[InPaddingEnvironmentKey.self] }
        set { self[InPaddingEnvironmentKey.self] = newValue }
    }
}

struct HorizontalPaddingEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 20
}

extension EnvironmentValues {
    var tabBarHorizontalPadding: CGFloat {
        get { self[HorizontalPaddingEnvironmentKey.self] }
        set { self[HorizontalPaddingEnvironmentKey.self] = newValue }
    }
}

struct BottomPaddingEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 10
}

extension EnvironmentValues {
    var tabBarBottomPadding: CGFloat {
        get { self[BottomPaddingEnvironmentKey.self] }
        set { self[BottomPaddingEnvironmentKey.self] = newValue }
    }
}

struct TabBarHeightEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGFloat = 30
}

extension EnvironmentValues {
    var tabBarHeight: CGFloat {
        get { self[TabBarHeightEnvironmentKey.self] }
        set { self[TabBarHeightEnvironmentKey.self] = newValue }
    }
}
