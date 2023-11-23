import SwiftUI

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
public extension Brick where Wrapped: View {

    /// Sets the visibility of the drag indicator on top of a sheet.
    ///
    /// You can show a drag indicator when it isn't apparent that a
    /// sheet can resize or when the sheet can't dismiss interactively.
    ///
    ///     struct ContentView: View {
    ///         @State private var showSettings = false
    ///
    ///         var body: some View {
    ///             Button("View Settings") {
    ///                 showSettings = true
    ///             }
    ///             .sheet(isPresented: $showSettings) {
    ///                 SettingsView()
    ///                     .presentationDetents:([.medium, .large])
    ///                     .presentationDragIndicator(.visible)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameter visibility: The preferred visibility of the drag indicator.
    @ViewBuilder
    func presentationDragIndicator(_ visibility: Visibility) -> some View {
        #if os(iOS) || targetEnvironment(macCatalyst)
        wrapped.background(Brick<Any>.Representable(visibility: visibility))
        #else
        wrapped
        #endif
    }

}

#if os(iOS) || targetEnvironment(macCatalyst)
private extension Brick where Wrapped == Any {
    struct Representable: UIViewControllerRepresentable {
        let visibility: Visibility

        func makeUIViewController(context: Context) -> Brick.Representable.Controller {
            Controller(visibility: visibility)
        }

        func updateUIViewController(_ controller: Brick.Representable.Controller, context: Context) {
            controller.update(visibility: visibility)
        }
    }
}

private extension Brick.Representable {
    final class Controller: UIViewController {

        var visibility: Visibility

        init(visibility: Visibility) {
            self.visibility = visibility
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(visibility: visibility)
        }

        override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
            update(visibility: visibility)
        }

        func update(visibility: Visibility) {
            self.visibility = visibility

            if let controller = parent?.sheetPresentationController {
                controller.animateChanges {
                    controller.prefersGrabberVisible = visibility == .visible
                    controller.prefersScrollingExpandsWhenScrolledToEdge = true
                }
            }
        }

    }
}
#endif
