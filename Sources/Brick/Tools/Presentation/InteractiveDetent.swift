import SwiftUI

// MARK: 交互式高度控制器/Interactive Detent Controller
// MARK: 用于控制弹出视图的交互式高度/Controls interactive detents for sheet presentation
#if os(iOS) || targetEnvironment(macCatalyst)
@available(iOS 15, *)
private extension Brick where Wrapped == Any {
    /// 交互式高度表示器/Interactive detent representable
    struct Representable: UIViewControllerRepresentable {
        /// 高度标识符/Detent identifier
        let identifier: Brick<Any>.PresentationDetent.Identifier?

        func makeUIViewController(context: Context) -> Brick.Representable.Controller {
            Controller(identifier: identifier)
        }

        func updateUIViewController(_ controller: Brick.Representable.Controller, context: Context) {
            controller.update(identifier: identifier)
        }
    }
}
@available(iOS 15, *)
private extension Brick.Representable {
    /// 交互式高度控制器/Interactive detent controller
    final class Controller: UIViewController {

        /// 高度标识符/Detent identifier
        var identifier: Brick<Any>.PresentationDetent.Identifier?

        /// 初始化/Initialize
        /// - Parameter identifier: 高度标识符/Detent identifier
        init(identifier: Brick<Any>.PresentationDetent.Identifier?) {
            self.identifier = identifier
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            update(identifier: identifier)
        }

        /// 更新高度标识符/Update detent identifier
        /// - Parameter identifier: 新的高度标识符/New detent identifier
        func update(identifier: Brick<Any>.PresentationDetent.Identifier?) {
            self.identifier = identifier

            if let controller = parent?.sheetPresentationController {
                controller.animateChanges {
                    controller.presentingViewController.view.tintAdjustmentMode = .normal
                    controller.largestUndimmedDetentIdentifier = identifier.flatMap {
                        .init(rawValue: $0.rawValue)
                    }
                }
            }
        }

    }
}
#endif
