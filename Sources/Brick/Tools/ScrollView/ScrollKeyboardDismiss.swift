import SwiftUI

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
@MainActor 
extension Brick where Wrapped: View {

    /// Configures the behavior in which scrollable content interacts with
    /// the software keyboard.
    ///
    /// You use this modifier to customize how scrollable content interacts
    /// with the software keyboard. For example, you can specify a value of
    /// ``ScrollDismissesKeyboardMode/immediately`` to indicate that you
    /// would like scrollable content to immediately dismiss the keyboard if
    /// present when a scroll drag gesture begins.
    ///
    ///     @State var text = ""
    ///
    ///     ScrollView {
    ///         TextField("Prompt", text: $text)
    ///         ForEach(0 ..< 50) { index in
    ///             Text("\(index)")
    ///                 .padding()
    ///         }
    ///     }
    ///     .scrollDismissesKeyboard(.immediately)
    ///
    /// You can also use this modifier to customize the keyboard dismissal
    /// behavior for other kinds of scrollable views, like a ``List`` or a
    /// ``TextEditor``.
    ///
    /// By default, a ``TextEditor`` is interactive while other kinds
    /// of scrollable content always dismiss the keyboard on a scroll
    /// when linked against iOS 16 or later. Pass a value of
    /// ``ScrollDismissesKeyboardMode/never`` to indicate that scrollable
    /// content should never automatically dismiss the keyboard.
    ///
    /// - Parameter mode: The keyboard dismissal mode that scrollable content
    ///   uses.
    ///
    /// - Returns: A view that uses the specified keyboard dismissal mode.
    public func scrollDismissesKeyboard(_ mode: Brick<Any>.ScrollDismissesKeyboardMode) -> some View {
        wrapped
            .environment(\.scrollDismissesKeyboardMode, mode)
#if os(iOS) || targetEnvironment(macCatalyst)
            .sibling(forType: UIScrollView.self) { proxy in
                let scrollView = proxy.instance
                guard scrollView.keyboardDismissMode != mode.scrollViewDismissMode else { return }
                scrollView.keyboardDismissMode = mode.scrollViewDismissMode
            }
#endif
    }

}

extension View {
    @available(visionOS, unavailable)
    public func scrollDismissesKeyboard() -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return AnyView(self.scrollDismissesKeyboard(.immediately))
        } else {
            return self.ss.scrollDismissesKeyboard(.immediately)
        }
    }
}
