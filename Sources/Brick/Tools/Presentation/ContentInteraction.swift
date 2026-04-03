import SwiftUI

@available(iOS, deprecated: 16.4)
@available(tvOS, deprecated: 16.4)
@available(macOS, deprecated: 13.3)
@available(watchOS, deprecated: 9.4)
public extension Brick<Any> {
    /// 用于影响弹出视图如何响应滑动手势的行为/A behavior that you can use to influence how a presentation responds to
    /// swipe gestures.
    ///
    /// 与 ``View/presentationContentInteraction(_:)`` 修饰符一起使用/Use values of this type with the
    /// ``View/presentationContentInteraction(_:)`` modifier.
    struct PresentationContentInteraction: Hashable {
        enum Interaction: Hashable {
            case automatic
            case resizes
            case scrolls
        }

        let interaction: Interaction

        /// 弹出视图的默认滑动手势行为/The default swipe behavior for the presentation.
        public static var automatic: PresentationContentInteraction { .init(interaction: .automatic) }

        /// 优先调整弹出视图大小而非滚动内容的行为/A behavior that prioritizes resizing a presentation when swiping, rather
        /// than scrolling the content of the presentation.
        public static var resizes: PresentationContentInteraction { .init(interaction: .resizes) }

        /// 优先滚动弹出视图内容而非调整大小的行为/A behavior that prioritizes scrolling the content of a presentation when
        /// swiping, rather than resizing the presentation.
        public static var scrolls: PresentationContentInteraction { .init(interaction: .scrolls) }
    }
}

@available(iOS, deprecated: 16.4)
@available(tvOS, deprecated: 16.4)
@available(macOS, deprecated: 13.3)
@available(watchOS, deprecated: 9.4)

public extension Brick where Wrapped: View {
    /// 设置弹出视图的内容交互行为/Sets how the presentation responds to swipe gestures.
    /// - Parameter interaction: 内容交互行为/The content interaction behavior
    @ViewBuilder @MainActor
    func presentationContentInteraction(_ interaction: Brick<Any>.PresentationContentInteraction) -> some View {
        #if os(iOS) || targetEnvironment(macCatalyst)
        if #available(iOS 15, *) {
            wrapped.background(Brick<Any>.Representable(interaction: interaction))
        } else {
            wrapped
        }
        #else
        wrapped
        #endif
    }
}

#if os(iOS) || targetEnvironment(macCatalyst)
@available(iOS 15, *)
private extension Brick where Wrapped == Any {
    struct Representable: UIViewControllerRepresentable {
        let interaction: Brick<Any>.PresentationContentInteraction

        func makeUIViewController(context: Context) -> Brick.Representable.Controller {
            Controller(interaction: interaction)
        }

        func updateUIViewController(_ controller: Brick.Representable.Controller, context: Context) {
            controller.update(interaction: interaction)
        }
    }
}
@available(iOS 15, *)
private extension Brick.Representable {
    final class Controller: UIViewController, UISheetPresentationControllerDelegate {
        var interaction: Brick<Any>.PresentationContentInteraction

        init(interaction: Brick<Any>.PresentationContentInteraction) {
            self.interaction = interaction
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(interaction: interaction)
        }

        override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            super.willTransition(to: newCollection, with: coordinator)
            update(interaction: interaction)
        }

        func update(interaction: Brick<Any>.PresentationContentInteraction) {
            self.interaction = interaction

            if let controller = parent?.sheetPresentationController {
                controller.animateChanges {
                    switch interaction.interaction {
                    case .automatic, .resizes:
                        controller.prefersScrollingExpandsWhenScrolledToEdge = true
                    case .scrolls:
                        controller.prefersScrollingExpandsWhenScrolledToEdge = false
                    }
                }
            }
        }
    }
}
#endif
