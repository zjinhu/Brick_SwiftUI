import SwiftUI

#if os(iOS) && !os(visionOS)
/// iOS 15+ 已废弃，建议使用原生 onSubmit
/// iOS 15+ deprecated, use native onSubmit
@available(iOS, deprecated: 15)

/// Brick 扩展：表单提交处理
/// Brick extension: Form submission handling
public extension Brick where Wrapped: View {
    /// Adds an action to perform when the user submits a value to this view.
    ///
    /// Different views may have different triggers for the provided action. A TextField, or SecureField will trigger this action when the user hits the hardware or software return key.
    ///
    ///     TextField("Username", text: $username)
    ///         .ss.onSubmit {
    ///             guard viewModel.validate() else { return }
    ///             viewModel.login()
    ///         }
    ///
    /// - Parameter action: 提交时触发的动作 / Action to perform on submit
    @MainActor @ViewBuilder
    func onSubmit(_ action: @escaping () -> Void) -> some View {
        Group {
            if #available(iOS 15, *) {
                wrapped
                    .onSubmit(action)
            } else {
                wrapped
            }
        }
        .modifier(SubmitModifier())
        .environment(\.submit, .init(submit: action))
    }

    /// A semantic label describing the label of submission within a view hierarchy.
    ///
    /// - Parameter label: 提交标签 / Submit label
    @MainActor @ViewBuilder
    func submitLabel(_ label: Brick<Any>.SubmitLabel) -> some View {
        Group {
            if #available(iOS 15, *) {
                wrapped
                    .submitLabel(.init(label))
            } else {
                wrapped
            }
        }
        .modifier(SubmitModifier())
        .environment(\.submitLabel, label)
    }
}

/// 提交标签枚举
/// Submit label enum
public extension Brick where Wrapped == Any {
    /// A semantic label describing the label of submission within a view hierarchy.
    struct SubmitLabel: Equatable {
        internal let returnKeyType: UIReturnKeyType
        fileprivate init(_ type: UIReturnKeyType) {
            returnKeyType = type
        }
    }
}

@available(iOS 15, *)
private extension SwiftUI.SubmitLabel {
    init(_ label: Brick<Any>.SubmitLabel) {
        switch label {
        case .continue: self = .continue
        case .done: self = .done
        case .go: self = .go
        case .join: self = .join
        case .next: self = .next
        case .return: self = .return
        case .route: self = .route
        case .search: self = .search
        case .send: self = .send
        default: self = .return
        }
    }
}

/// 提交标签静态属性
/// Submit label static properties
public extension Brick.SubmitLabel {
    /// "Continue" / 继续
    static var `continue`: Self { .init(.continue) }
    /// "Done" / 完成
    static var done: Self { .init(.done) }
    /// "Go" / 前往
    static var go: Self { .init(.go) }
    /// "Join" / 加入
    static var join: Self { .init(.join) }
    /// "Next" / 下一步
    static var next: Self { .init(.next) }
    /// "Return" / 返回
    static var `return`: Self { .init(.default) }
    /// "Route" / 路线
    static var route: Self { .init(.route) }
    /// "Search" / 搜索
    static var search: Self { .init(.search) }
    /// "Send" / 发送
    static var send: Self { .init(.send) }
}

/// 提交动作
/// Submit action
internal struct SubmitAction {
    let submit: () -> Void
    func callAsFunction() { submit() }
}

/// 提交环境键
/// Submit environment key
private struct SubmitEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: SubmitAction = .init(submit: { })
}

internal extension EnvironmentValues {
    var submit: SubmitAction {
        get { self[SubmitEnvironmentKey.self] }
        set { self[SubmitEnvironmentKey.self] = newValue }
    }
}

/// 提交标签环境键
/// Submit label environment key
private struct SubmitLabelEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Brick.SubmitLabel = .return
}

internal extension EnvironmentValues {
    var submitLabel: Brick<Any>.SubmitLabel {
        get { self[SubmitLabelEnvironmentKey.self] }
        set { self[SubmitLabelEnvironmentKey.self] = newValue }
    }
}

/// 提交修饰器
/// Submit modifier
private struct SubmitModifier: ViewModifier {
    @Environment(\.submit) private var submit
    @Environment(\.submitLabel) private var label

    @StateObject private var coordinator: Coordinator = .init()

    func body(content: Content) -> some View {
        content
            .any(forType: UITextView.self) { proxy in
                proxy.instance.returnKeyType = label.returnKeyType
            }
            .any(forType: UITextField.self) { proxy in
                let view = proxy.instance
                view.returnKeyType = label.returnKeyType
                coordinator.onReturn = { submit() }
                coordinator.observe(view: view)
            }
    }

    /// 协调器 / Coordinator
    final class Coordinator: NSObject, ObservableObject {
        private(set) weak var field: UITextField?

        var onReturn: () -> Void = { }
        @objc private func didReturn() { onReturn() }

        override init() { }

        @MainActor func observe(view: UITextField) {
            view.addTarget(self, action: #selector(didReturn), for: .editingDidEndOnExit)
        }
    }
}
#endif
