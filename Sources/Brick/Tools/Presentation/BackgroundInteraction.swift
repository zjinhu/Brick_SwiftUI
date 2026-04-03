import SwiftUI

@available(iOS, deprecated: 16.4)
@available(tvOS, deprecated: 16.4)
@available(macOS, deprecated: 13.3)
@available(watchOS, deprecated: 9.4)
extension Brick<Any> {
    /// 弹出视图后方可用的交互类型/The kinds of interaction available to views behind a presentation.
    ///
    /// 与 ``View/presentationBackgroundInteraction(_:)`` 修饰符一起使用/Use values of this type with the
    /// ``View/presentationBackgroundInteraction(_:)`` modifier.
    public struct PresentationBackgroundInteraction: Hashable {
        /// 交互类型/Interaction type
        enum Interaction: Hashable {
            case automatic
            case enabled
            case upThrough(detent: Brick.PresentationDetent)
            case disabled
        }

        let interaction: Interaction

        /// 弹出视图的默认背景交互/The default background interaction for the presentation.
        public static var automatic: Self { .init(interaction: .automatic) }

        /// 用户可以与弹出视图后面的视图交互/People can interact with the view behind a presentation.
        public static var enabled: Self { .init(interaction: .enabled) }

        /// 用户可以在指定高度范围内与弹出视图后面的视图交互/People can interact with the view behind a presentation up through a
        /// specified detent.
        ///
        /// 在大于指定高度时，SwiftUI 会禁用交互/At detents larger than the one you specify, SwiftUI disables
        /// interaction.
        ///
        /// - Parameter detent: 用户可以交互的最大高度/The largest detent at which people can interact with
        ///   the view behind the presentation.
        public static func enabled(upThrough detent: Brick.PresentationDetent) -> Self { .init(interaction: .upThrough(detent: detent))}

        /// 用户无法与弹出视图后面的视图交互/People can't interact with the view behind a presentation.
        public static var disabled: Self { .init(interaction: .disabled) }
    }
}

@available(iOS, deprecated: 16.4)
@available(tvOS, deprecated: 16.4)
@available(macOS, deprecated: 13.3)
@available(watchOS, deprecated: 9.4)
public extension Brick where Wrapped: View {
    /// 控制用户是否可以与弹出视图后面的视图交互/Controls whether people can interact with the view behind a
    /// presentation.
    ///
    /// 在许多平台上，SwiftUI 会自动禁用弹出视图后面的视图交互/On many platforms, SwiftUI automatically disables the view behind a
    /// sheet that you present, so that people can't interact with the backing
    /// view until they dismiss the sheet. 如果希望启用交互，请使用此修饰符/Use this modifier if you want to
    /// enable interaction.
    /// The following example enables people to interact with the view behind
    /// the sheet when the sheet is at the smallest detent, but not at the other
    /// detents:
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
    ///                     .presentationDetents(
    ///                         [.medium, .large])
    ///                     .presentationBackgroundInteraction(
    ///                         .enabled(upThrough: .medium))
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - interaction: 用户如何与弹出视图后面视图交互的规范/A specification of how people can interact with the
    ///     view behind a presentation.
    @ViewBuilder @MainActor
    func presentationBackgroundInteraction(_ interaction: Brick<Any>.PresentationBackgroundInteraction) -> some View {
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
        let interaction: Brick<Any>.PresentationBackgroundInteraction

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
    /// 背景交互控制器/Background interaction controller
    final class Controller: UIViewController, UISheetPresentationControllerDelegate {
        /// 交互类型/Interaction type
        var interaction: Brick<Any>.PresentationBackgroundInteraction
        /// 委托/Delegate
        weak var _delegate: UISheetPresentationControllerDelegate?

        /// 初始化/Initialize
        /// - Parameter interaction: 交互类型/Interaction type
        init(interaction: Brick<Any>.PresentationBackgroundInteraction) {
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

        /// 更新交互类型/Update interaction type
        /// - Parameter interaction: 新的交互类型/New interaction type
        func update(interaction: Brick<Any>.PresentationBackgroundInteraction) {
            self.interaction = interaction

            if let controller = parent?.sheetPresentationController {
                controller.animateChanges {
                    switch interaction.interaction {
                    case .automatic:
                        controller.largestUndimmedDetentIdentifier = nil
                        controller.presentingViewController.view?.tintAdjustmentMode = .automatic
                    case .disabled:
                        controller.largestUndimmedDetentIdentifier = nil
                        controller.presentingViewController.view?.tintAdjustmentMode = .automatic
                    case .enabled:
                        controller.largestUndimmedDetentIdentifier = .large
                        controller.presentingViewController.view?.tintAdjustmentMode = .normal
                    case .upThrough(let detent):
                        controller.largestUndimmedDetentIdentifier = .init(detent.id.rawValue)

                        let selectedId = controller.selectedDetentIdentifier ?? .large
                        let selected = Brick<Any>.PresentationDetent(id: .init(rawValue: selectedId.rawValue))
                        controller.presentingViewController.view?.tintAdjustmentMode = selected > detent ? .dimmed : .normal
                    }
                }
            }
        }
    }
}
#endif
