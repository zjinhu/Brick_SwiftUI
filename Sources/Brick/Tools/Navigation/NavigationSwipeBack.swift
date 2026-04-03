//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/26/24.
//

import SwiftUI
#if os(iOS)
import UIKit

/// View扩展/View extension
extension View {
    /// 恢复滑动返回/Regain swipe back
    /// 恢复被禁用的滑动返回手势。/Regain the disabled swipe back gesture.
    public func regainSwipeBack() -> some View {
        self.background(
            RegainSwipeBackView()
        )
    }
}

/// 恢复滑动返回视图/Regain swipe back view
struct RegainSwipeBackView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = RegainSwipeBackViewController
    
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

/// 恢复滑动返回视图控制器/Regain swipe back view controller
class RegainSwipeBackViewController: UIViewController {
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let parent = parent?.parent,
           let navigationController = parent.navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}

//extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = self
//    }
//
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return viewControllers.count > 1
//    }
//}
#endif
