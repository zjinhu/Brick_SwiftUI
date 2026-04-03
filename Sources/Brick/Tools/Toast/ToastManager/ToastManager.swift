//
//  ToastManager.swift
//  Toast
//
//  Created by iOS on 2023/5/4.
//  Toast管理器/Toast manager
//  用于显示和管理Toast提示/Used to display and manage Toast prompts

import SwiftUI
#if !os(visionOS)
/// View扩展 - 添加Toast/View extension - Add Toast
public extension View {
    /// 添加Toast/Add Toast
    /// - Parameter ob: ToastManager实例/ToastManager instance
    /// - Returns: 应用了Toast的视图/View with Toast applied
    func addToast(_ ob: ToastManager) -> some View {
        self.addToast(
            isActive: ob.isActiveBinding,
            padding: ob.padding,
            position: ob.position,
            content: { ob.content }
        )
    }
}

/// ToastManager扩展/ToastManager extension
extension ToastManager {
    /// 显示文本消息/Show text message
    /// - Parameter text: 要显示的文本/Text to display
    public func showText(_ text: String){
        show {
            MessageView(text: text)
        }
    }
}

/// Toast管理器类/Toast manager class
@MainActor
public class ToastManager: ObservableObject {
    /// 初始化Toast管理器/Initialize Toast manager
    /// - Parameter position: Toast显示位置/Toast display position
    public init(position: ToastPosition = .bottom) {
        self.position = position
    }
    
    
    /// Toast停留时长（秒）/Toast display duration (seconds)
    public var duration: TimeInterval = 3
    /// Toast显示位置/Toast display position
    public var position: ToastPosition
    /// Toast距离屏幕边缘的距离/Distance from Toast to screen edge
    public var padding: CGFloat = 10
 
    typealias Action = @MainActor @Sendable () -> Void

    private var presentationId = UUID()
    
    /// Toast内容/Toast content
    @Published var content = AnyView(EmptyView())
    
    /// Toast是否激活/Whether Toast is active
    @Published var isActive = false

    /// 激活状态绑定/Active state binding
    var isActiveBinding: Binding<Bool> {
        .init(get: { self.isActive },
              set: { self.isActive = $0 }
        )
    }

}

/// ToastManager方法扩展/ToastManager method extension
extension ToastManager {
    /// 隐藏Toast/Hide Toast
    func dismiss() {
        dismiss { @MainActor in }
    }
    /// 隐藏Toast（带回调）/Hide Toast (with callback)
    /// - Parameter completion: 隐藏完成后的回调/Callback after hide completes
    func dismiss(completion: @escaping @MainActor @Sendable () -> Void) {
        guard isActive else { 
            Task { @MainActor in completion() }
            return
        }
        isActive = false
        perform(after: 0.3, action: completion)
    }
    /// 显示Toast，自动隐藏/Show Toast, auto hide
    /// - Parameter content: Toast内容视图/Toast content view
    public func show<Content: View>(_ content: Content) {
        dismiss { @MainActor in
            self.showAfterDismiss(content: content)
        }
    }
    /// 显示Toast（手动隐藏）/Show Toast (manual hide)
    /// - Parameter content: Toast内容视图构建闭包/Toast content view build closure
    public func show<Content: View>(@ViewBuilder _ content: @escaping () -> Content) {
        show(content())
    }
}

/// Toast位置枚举/Toast position enum
public enum ToastPosition {
    /// 顶部显示/Display at top
    case top
    /// 底部显示/Display at bottom
    case bottom
    
    public var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

/// ToastManager私有扩展/ToastManager private extension
private extension ToastManager {

    /// 执行操作/Perform action
    /// - Parameters:
    ///   - action: 要执行的操作/Action to perform
    ///   - seconds: 延迟秒数/Delay seconds
    func perform(_ action: @escaping @MainActor @Sendable () -> Void,
                 after seconds: TimeInterval) {
        Task { @MainActor in
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                try? await Task.sleep(for: .seconds(seconds))
            } else {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            }
            action()
        }
    }
    
    /// 延迟执行操作/Perform action after delay
    func perform(after seconds: TimeInterval,
                 action: @escaping @MainActor @Sendable () -> Void) {
        perform(action, after: seconds)
    }
    
    /// 隐藏后显示/Show after dismiss
    func showAfterDismiss<Content: View>(content: Content) {
        let id = UUID()
        self.presentationId = id

        self.content = AnyView(content)
        perform(setActive, after: 0.1)
        perform(after: self.duration) { @MainActor in
            guard id == self.presentationId else { return }
            self.dismiss()
        }
    }
    
    /// 设置激活状态/Set active state
    func setActive() {
        isActive = true
    }
}

/// View扩展 - 添加Toast/View extension - Add Toast
extension View {

    /// 添加Toast视图/Add Toast view
    /// - Parameters:
    ///   - isActive: 激活状态绑定/Active state binding
    ///   - padding: 内边距/Padding
    ///   - position: 显示位置/Display position
    ///   - content: 内容视图构建闭包/Content view build closure
    /// - Returns: 应用了Toast的视图/View with Toast applied
    private func addToast<Content: View>(isActive: Binding<Bool>,
                                 padding: CGFloat = 10,
                                 position: ToastPosition = .bottom,
                                 content: @escaping () -> Content) -> some View {
        
        ZStack(alignment: position.alignment) {
            self
            if position == .top{
                ToastView(
                    isActive: isActive,
                    padding: padding,
                    defaultOffset: -500,
                    content: { _ in content() }
                )
            }else{
                ToastView(
                    isActive: isActive,
                    padding: padding,
                    defaultOffset: 500, 
                    content: { _ in content() }
                )
            }

        }
    }
 
}
#endif
