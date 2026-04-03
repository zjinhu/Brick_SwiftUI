//
//  AppColorScheme.swift
//  SwiftBrick
//
//  Created by 狄烨 on 2023/6/6.
//

import SwiftUI
import Foundation
#if os(iOS)

/// 颜色方案类型/Color scheme type
/// 应用主题模式枚举。/App theme mode enumeration.
public enum ColorSchemeType: Int {
    /// 跟随系统/Follow system
    case system
    /// 浅色模式/Light mode
    case light
    /// 暗黑模式/Dark mode
    case dark
}

/// 应用颜色方案管理器/App color scheme manager
/// 管理应用的主题模式（浅色/暗黑/跟随系统）。/Manages app theme mode (light/dark/follow system).
@MainActor
public class AppColorScheme: ObservableObject {

    /// 初始化颜色方案管理器/Initialize color scheme manager
    public init() { }
    
    /// 暗黑模式设置/Dark mode setting
    /// 修改时自动更新窗口样式。/Automatically updates window style when changed.
    @Published public var darkModeSetting: ColorSchemeType = ColorSchemeType(rawValue: UserDefaults.standard.integer(forKey: "colorSchemeType")) ?? .system {
        didSet {
            UserDefaults.standard.set(darkModeSetting.rawValue, forKey: "colorSchemeType")
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            switch darkModeSetting {
            case .light:
                window?.overrideUserInterfaceStyle = .light
            case .dark:
                window?.overrideUserInterfaceStyle = .dark
            default:
                window?.overrideUserInterfaceStyle = .unspecified
            }
        }
    }
}

#endif


