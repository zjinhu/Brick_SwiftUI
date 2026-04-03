//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//

import SwiftUI
import Combine

#if os(iOS)

/// 键盘管理器 / Keyboard manager
/// 用于跟踪键盘高度变化 / Tracks keyboard height changes
@MainActor
public class KeyboardManager: ObservableObject {
    /// 当前键盘高度 / Current keyboard height
    @Published public var keyboardHeight: CGFloat = 0
    private var subscription: [AnyCancellable] = []

    public init() {
        subscribeToKeyboardEvents()
    }
}

/// 键盘管理器扩展 / Keyboard manager extensions
extension KeyboardManager {
    /// 隐藏键盘 / Hide keyboard
    public static func hideKeyboard() { 
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/// 私有扩展 / Private extension
private extension KeyboardManager {
    /// 订阅键盘事件 / Subscribe to keyboard events
    func subscribeToKeyboardEvents() {
        Publishers.Merge(getKeyboardWillOpenPublisher(), createKeyboardWillHidePublisher())
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .sink { self.keyboardHeight = $0 }
            .store(in: &subscription)
    }
}

/// 私有扩展 / Private extension
private extension KeyboardManager {
    /// 获取键盘即将打开的发布者 / Get keyboard will open publisher
    func getKeyboardWillOpenPublisher() -> Publishers.CompactMap<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { max(0, $0.height - 8)
            }
    }
    
    /// 创建键盘即将隐藏的发布者 / Create keyboard will hide publisher
    func createKeyboardWillHidePublisher() -> Publishers.Map<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in .zero }
    }
}
#elseif os(macOS)

/// macOS 键盘管理器 / macOS keyboard manager
public class KeyboardManager: ObservableObject {
    public var keyboardHeight: CGFloat = 0
    public init() {}
}

extension KeyboardManager {
    /// 隐藏键盘 / Hide keyboard
    public static func hideKeyboard() {
        DispatchQueue.main.async { NSApp.keyWindow?.makeFirstResponder(nil)
        }
    }
}
#elseif os(tvOS)

/// tvOS 键盘管理器 / tvOS keyboard manager
class KeyboardManager: ObservableObject {
    private(set) var keyboardHeight: CGFloat = 0
}

extension KeyboardManager {
    /// 隐藏键盘 / Hide keyboard (no-op for tvOS)
    static func hideKeyboard() {}
}
#endif
