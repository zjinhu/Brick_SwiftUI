//
//  File.swift
//  
//
//  Created by 狄烨 on 2023/6/24.
//

import UIKit
import Foundation

extension UIWindow {
    /// get window
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .sorted { $0.activationState.sortPriority < $1.activationState.sortPriority }
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.windows.first { $0.isKeyWindow } }
            .first
    }
}

extension UIWindowScene {
    /// Get UIWindowScene
    public static var currentWindowSence: UIWindowScene?  {
        for scene in UIApplication.shared.connectedScenes{
            if scene.activationState == .foregroundActive{
                return scene as? UIWindowScene
            }
        }
        return nil
    }
}
 

extension UIScreen {
    public static var safeArea: UIEdgeInsets {
        UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)?
            .safeAreaInsets ?? .zero
    }
    
    /// 当前屏幕状态 宽度
    public static var realHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    /// 当前屏幕状态 高度
    public static var realWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
}

private extension UIScene.ActivationState {
    var sortPriority: Int {
        switch self {
        case .foregroundActive: return 1
        case .foregroundInactive: return 2
        case .background: return 3
        case .unattached: return 4
        @unknown default: return 5
        }
    }
}
