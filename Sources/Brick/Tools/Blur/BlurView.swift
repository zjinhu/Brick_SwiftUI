//
//  BlurView.swift
//  模糊视图/Blur view
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI
import Foundation
#if os(macOS)
import AppKit

/// 模糊视图 (macOS)/Blur view (macOS)
/// 使用 NSVisualEffectView 实现模糊效果/Uses NSVisualEffectView for blur effect
public struct BlurView: NSViewRepresentable {
    public typealias NSViewType = NSVisualEffectView
    
    /// 初始化模糊视图/Initialize blur view
    public init() { }
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = .hudWindow
        effectView.blendingMode = .withinWindow
        effectView.state = NSVisualEffectView.State.active
        return effectView
    }
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .hudWindow
        nsView.blendingMode = .withinWindow
    }
}
#elseif os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
import UIKit

/// 模糊视图 (iOS/tvOS)/Blur view (iOS/tvOS)
/// 使用 UIVisualEffectView 实现模糊效果/Uses UIVisualEffectView for blur effect
public struct BlurView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView
    
    /// 初始化模糊视图/Initialize blur view
    public init() { }
    
    /// 创建 UIView/UIView to create
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    
    /// 更新 UIView/Update UIView
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemMaterial)
    }
}

#endif
