import SwiftUI
 
#if os(iOS) && !os(visionOS)

public extension Brick where Wrapped: View {
    func focused<Value>(_ binding: Binding<Value?>, equals value: Value) -> some View where Value: Hashable {
        wrapped.modifier(FocusModifier(focused: binding, value: value))
    }
}


private struct FocusModifier<Value: Hashable>: ViewModifier {
    @Environment(\.submit) private var submit
    @StateObject private var coordinator = Coordinator()
    @Binding var focused: Value?
    var value: Value

    func body(content: Content) -> some View {
        content
            // this ensures when the field goes out of view, it doesn't retain focus
            .onWillDisappear { focused = nil }
            .sibling(forType: UITextField.self) { proxy in
                let view = proxy.instance
                coordinator.observe(field: view)

                coordinator.onBegin = {
                    focused = value
                }

                coordinator.onReturn = {
                    submit()
                }

                coordinator.onEnd = {
                    guard focused == value else { return }
                    focused = nil
                }

                if focused == value, view.isUserInteractionEnabled, view.isEnabled {
                    view.becomeFirstResponder()
                }
            }
            .ss.onChange(of: focused) { newValue in
                if newValue == nil {
                    coordinator.field?.resignFirstResponder()
                }
            }
    }
}

private final class Coordinator: NSObject, ObservableObject, UITextFieldDelegate {
    private(set) weak var field: UITextField?
    weak var _delegate: UITextFieldDelegate?

    var onBegin: () -> Void = { }
    var onReturn: () -> Void = { }
    var onEnd: () -> Void = { }

    override init() { }

    func observe(field: UITextField) {
        self.field = field

        if field.delegate !== self {
            _delegate = field.delegate
            field.delegate = self
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        _delegate?.textFieldDidBeginEditing?(textField)
        onBegin()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        _delegate?.textFieldDidEndEditing?(textField)
        onEnd()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onReturn()
        // prevent auto-resign
        return false
    }

    override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) { return true }
        if _delegate?.responds(to: aSelector) ?? false { return true }
        return false
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) { return self }
        return _delegate
    }
}

#endif
