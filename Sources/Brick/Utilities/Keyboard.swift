//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//

import SwiftUI
import Combine

#if os(iOS)
@MainActor
public class KeyboardManager: ObservableObject {
    @Published public var keyboardHeight: CGFloat = 0
    private var subscription: [AnyCancellable] = []

    public init() {
        subscribeToKeyboardEvents()
    }
}

extension KeyboardManager {
    public static func hideKeyboard() { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

private extension KeyboardManager {
    func subscribeToKeyboardEvents() {
        Publishers.Merge(getKeyboardWillOpenPublisher(), createKeyboardWillHidePublisher())
            .debounce(for: .milliseconds(50), scheduler: DispatchQueue.main)
            .sink { self.keyboardHeight = $0 }
            .store(in: &subscription)
    }
}
private extension KeyboardManager {
    func getKeyboardWillOpenPublisher() -> Publishers.CompactMap<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { max(0, $0.height - 8)
            }
    }
    func createKeyboardWillHidePublisher() -> Publishers.Map<NotificationCenter.Publisher, CGFloat> {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in .zero }
    }
}
#elseif os(macOS)
public class KeyboardManager: ObservableObject {
    public var keyboardHeight: CGFloat = 0
    public init() {}
}
extension KeyboardManager {
    public static func hideKeyboard() {
        DispatchQueue.main.async { NSApp.keyWindow?.makeFirstResponder(nil)
        }
    }
}
#elseif os(tvOS)
class KeyboardManager: ObservableObject {
    private(set) var keyboardHeight: CGFloat = 0
}

extension KeyboardManager {
    static func hideKeyboard() {}
}
#endif
