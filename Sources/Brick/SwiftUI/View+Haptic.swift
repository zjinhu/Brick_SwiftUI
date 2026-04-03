//
//  View+Haptic.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2023/4/20.
//  触觉反馈扩展 - 提供触觉反馈功能 / Haptic feedback extension - provides haptic feedback functionality
//

//#if os(iOS) || os(macOS) || os(tvOS) || targetEnvironment(macCatalyst)
#if os(iOS) || targetEnvironment(macCatalyst)
import Foundation
import SwiftUI
import UIKit
#if canImport(CoreHaptics)
import CoreHaptics
#endif

// MARK: - HapticButton

/// 触觉按钮 - 带触觉反馈的按钮 / Haptic button - button with haptic feedback
public struct HapticButton<Content: View> : View {
    
    /// 是否开启触觉反馈 / Whether haptic feedback is enabled
    @AppStorage("isOpenHaptic") var isOpenHaptic: Bool = true
    
    /// 触觉反馈强度 / Haptic feedback intensity
    var haptic:  UIImpactFeedbackGenerator.FeedbackStyle = .medium
    let content: Content
    var action: () -> () = {}
    
    /// 初始化触觉按钮 / Initialize haptic button
    /// - Parameters:
    ///   - action: 点击回调 / Tap callback
    ///   - label: 标签构建器 / Label builder
    public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.content = label()
        self.action = action
    }
    
    /// 初始化触觉按钮 (带强度) / Initialize haptic button with intensity
    /// - Parameters:
    ///   - action: 点击回调 / Tap callback
    ///   - content: 内容构建器 / Content builder
    ///   - hapticIntensity: 触觉强度 / Haptic intensity
    public init(action: @escaping () -> Void,
                @ViewBuilder content: @escaping () -> Content,
                hapticIntensity: UIImpactFeedbackGenerator.FeedbackStyle) {
        self.content = content()
        self.action = action
        self.haptic = hapticIntensity
    }
    
    public var body: some View {
        Button {
            if isOpenHaptic {
                hapticFeedback()
            }
            action()
        } label: {
            content
        }
        
    }
}

// MARK: - View Haptics Extension

/// View 触觉反馈扩展 / View haptics extension
public extension View {
    
    /// 值变化时触发触觉反馈 / Trigger haptic feedback on value change
    /// - Parameters:
    ///   - value: 监听的值 / Value to listen
    ///   - type: 反馈类型 / Feedback type
    ///   - isOpen: 是否开启 / Whether enabled
    func haptics<V: Equatable>(onChangeOf value: V,
                               type: UINotificationFeedbackGenerator.FeedbackType,
                               isOpen: Bool = true) -> some View {
        onChange(of: value) { _ in
            if isOpen{
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(type)
            }
        }
    }
    
    /// 属性等于指定值时触发触觉反馈 / Trigger haptic feedback when property equals value
    /// - Parameters:
    ///   - property: 监听的属性 / Property to listen
    ///   - value: 目标值 / Target value
    ///   - type: 反馈类型 / Feedback type
    ///   - isOpen: 是否开启 / Whether enabled
    func haptics<V: Equatable>(when property: V,
                               equalsTo value: V,
                               type: UINotificationFeedbackGenerator.FeedbackType,
                               isOpen: Bool = true) -> some View {
        onChange(of: property) { newValue in
            if newValue == value, isOpen{
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(type)
            }
        }
    }
    
    /// 值变化时触发冲击触觉反馈 / Trigger impact haptic feedback on value change
    /// - Parameters:
    ///   - value: 监听的值 / Value to listen
    ///   - type: 冲击样式 / Impact style
    ///   - isOpen: 是否开启 / Whether enabled
    func haptics<V: Equatable>(onChangeOf value: V,
                               type: UIImpactFeedbackGenerator.FeedbackStyle,
                               isOpen: Bool = true) -> some View {
        onChange(of: value) { _ in
            if isOpen{
                let generator = UIImpactFeedbackGenerator(style: type)
                generator.prepare()
                generator.impactOccurred()
            }
        }
    }
    
    /// 属性等于指定值时触发冲击触觉反馈 / Trigger impact haptic when property equals value
    /// - Parameters:
    ///   - property: 监听的属性 / Property to listen
    ///   - value: 目标值 / Target value
    ///   - type: 冲击样式 / Impact style
    ///   - isOpen: 是否开启 / Whether enabled
    func haptics<V: Equatable>(when property: V,
                               equalsTo value: V,
                               type: UIImpactFeedbackGenerator.FeedbackStyle,
                               isOpen: Bool = true) -> some View {
        onChange(of: property) { newValue in
            if newValue == value, isOpen{
                let generator = UIImpactFeedbackGenerator(style: type)
                generator.prepare()
                generator.impactOccurred()
            }
        }
    }
    
    /// 值变化时触发选择触觉反馈 / Trigger selection haptic feedback on value change
    /// - Parameters:
    ///   - value: 监听的值 / Value to listen
    ///   - isOpen: 是否开启 / Whether enabled
    func haptics<V: Equatable>(onChangeOf value: V,
                               isOpen: Bool = true) -> some View {
        onChange(of: value) { _ in
            if isOpen{
                let generator = UISelectionFeedbackGenerator()
                generator.prepare()
                generator.selectionChanged()
            }
        }
    }
    
    /// 出现时触发触觉反馈 / Trigger haptic feedback when appear
    func triggersHapticFeedbackWhenAppear() -> some View {
        onAppear {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
    
}

// MARK: - Global Haptic Functions / 全局触觉函数

/// 全局触觉反馈函数 - 选择反馈 / Global haptic feedback function - selection feedback
/// 使用方式: `.haptics(onChangeOf:)` on your `View`
@MainActor public func hapticFeedback() {
    let generator = UISelectionFeedbackGenerator()
    generator.prepare()
    generator.selectionChanged()
}

/// 全局触觉反馈函数 - 通知反馈 / Global haptic feedback function - notification feedback
/// 使用方式: `.haptics(onChangeOf:type:)` on your `View`
@MainActor public func hapticFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    generator.notificationOccurred(type)
}

/// 全局触觉反馈函数 - 冲击反馈 / Global haptic feedback function - impact feedback
/// 使用方式: `.haptics(onChangeOf:type:)` on your `View`
@MainActor public func hapticFeedback(type: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: type)
    generator.prepare()
    generator.impactOccurred()
}
#endif
