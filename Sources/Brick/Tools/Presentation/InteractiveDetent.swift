import SwiftUI

#if os(iOS) || targetEnvironment(macCatalyst)
private extension Brick where Wrapped == Any {
    struct Representable: UIViewControllerRepresentable {
        let identifier: Brick<Any>.PresentationDetent.Identifier?

        func makeUIViewController(context: Context) -> Brick.Representable.Controller {
            Controller(identifier: identifier)
        }

        func updateUIViewController(_ controller: Brick.Representable.Controller, context: Context) {
            controller.update(identifier: identifier)
        }
    }
}

private extension Brick.Representable {
    final class Controller: UIViewController {

        var identifier: Brick<Any>.PresentationDetent.Identifier?

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
