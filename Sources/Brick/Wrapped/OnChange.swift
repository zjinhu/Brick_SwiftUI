import SwiftUI
import Combine

/// Brick 扩展：统一的 onChange 处理，兼容各 iOS 版本
/// Brick extension: Unified onChange handler compatible with all iOS versions
public extension Brick where Wrapped: View {

    /// Adds a modifier for this view that fires an action when a specific
    /// value changes.
    ///
    /// `onChange` is called on the main thread. Avoid performing long-running
    /// tasks on the main thread. If you need to perform a long-running task in
    /// response to `value` changing, you should dispatch to a background queue.
    ///
    /// The new value is passed into the closure.
    ///
    /// - Parameters:
    ///   - value: The value to observe for changes
    ///   - action: A closure to run when the value changes.
    ///   - newValue: The new value that changed
    ///
    /// - Returns: A view that fires an action when the specified value changes.

    /// 值变化时触发动作 (仅传递新值)
    /// Fire action when value changes (new value only)
    @ViewBuilder
    func onChange<Value: Equatable>(of value: Value, initial: Bool = false, _ action: @escaping (Value) -> Void) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            wrapped.onChange(of: value, initial: initial) { oldValue, newValue in
                action(newValue)
            }
        } else {
            wrapped.onChange(of: value, perform: action)
        }
    }
    
    /// 值变化时触发动作 (无参数闭包)
    /// Fire action when value changes (no parameter closure)
    @ViewBuilder
    func onChange<Value: Equatable>(of value: Value, initial: Bool = false, _ action: @escaping () -> Void) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            wrapped.onChange(of: value, initial: initial) {
                action()
            }
        } else {
            wrapped.onChange(of: value){ _ in
                action()
            }
        }
    }
  
    /// 值变化时触发动作 (传递旧值和新值)
    /// Fire action when value changes (old and new value)
    /// - Parameters:
    ///   - value: 要观察的值 / Value to observe
    ///   - initial: 是否在初始时触发 / Whether to trigger on initial
    ///   - action: 回调闭包，接收旧值和新值 / Callback with old and new value
    @MainActor @ViewBuilder
    func onChange<Value: Equatable>(of value: Value, initial: Bool = false, _ action: @escaping (Value, Value) -> Void) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            wrapped.onChange(of: value, initial: initial, action)
        } else {
            wrapped.modifier(BackportOnChangeModifier(value: value, initial: initial, action: action))
        }
    }
    
//兼容ios13
//    @ViewBuilder
//    func onChange<Value: Equatable>(of value: Value, perform action: @escaping (Value) -> Void) -> some View {
//        if #available(iOS 14, tvOS 14, macOS 11, watchOS 7, *) {
//            wrapped.onChange(of: value, perform: action)
//        } else {
//            wrapped.modifier(ChangeModifier(value: value, action: action))
//        }
//    }

}

/// iOS 13 的 onChange 回退修饰器
/// Backport onChange modifier for iOS 13
//private struct ChangeModifier<Value: Equatable>: ViewModifier {
//    let value: Value
//    let action: (Value) -> Void
//
//    @State var oldValue: Value?
//
//    init(value: Value, action: @escaping (Value) -> Void) {
//        self.value = value
//        self.action = action
//        _oldValue = .init(initialValue: value)
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .onReceive(Just(value)) { newValue in
//                guard newValue != oldValue else { return }
//                action(newValue)
//                oldValue = newValue
//            }
//    }
//}
 
/// 回退的 onChange 修饰器 (iOS 14-16)
/// Backport onChange modifier (iOS 14-16)
struct BackportOnChangeModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let initial: Bool
    let action: (Value, Value) -> Void
    
    @State private var previousValue: Value?
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !hasAppeared {
                    hasAppeared = true
                    if initial {
                        // 对于 initial 情况，我们使用相同的值作为 oldValue
                        // For initial case, use the same value as oldValue
                        action(value, value)
                    }
                }
                previousValue = value
            }
            .onChange(of: value) { newValue in
                let oldValue = previousValue ?? newValue
                previousValue = newValue
                action(oldValue, newValue)
            }
    }
}
