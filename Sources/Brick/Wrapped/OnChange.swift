import SwiftUI
import Combine
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
///ios13
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
