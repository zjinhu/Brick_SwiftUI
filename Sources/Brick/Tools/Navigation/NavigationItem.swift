//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/7/5.
//

import Foundation
import SwiftUI
#if os(iOS)
import UIKit

extension View {
    /// 访问底层UINavigationController的NavigationItem/Access the NavigationItem of the underlying `UINavigationController`
    ///
    /// 请将navigationItem()或navigationItem(customize:)附加到NavigationView上，或使用NavigationItemView。
    /// Please attach `navigationItem()` or `navigationItem(customize:)` to your `NavigationView` or simply use `NavigationItemView`
    /// 这将把底层的UINavigationController暴露在Environment中以便更方便地访问。
    /// This will expose the underlying `UINavigationController` in the `Environment` for easier access.
    ///
    /// 虽然没有这个NavigationItem仍然可以被找到，但在某些情况下可能会延迟或出现故障。
    /// While the `NavigationItem` will still be found without this, it may be delayed or glitchy without this in certain situations.
    ///
    /// - Parameter animated: 传递true表示动画显示自定义；否则传递false。默认为true/Pass `true` to animate the customization; otherwise, pass `false`. Defaults to `true`
    /// - Parameter customize: 带有找到的UINavigationItem的回调/Callback with the found `UINavigationItem`
    public func navigationItem(animated: Bool = true, customize: @escaping (UINavigationItem) -> Void) -> some View {
        modifier(NavigationControllerModifier(animated: animated, customize: customize))
    }
    
    /// 隐藏返回按钮标题/Hide back button title
    /// 隐藏导航栏返回按钮的标题。/Hides the title of the navigation bar back button.
    public func hiddenBackButtonTitle() -> some View {
        modifier(
            NavigationControllerModifier(animated: true){ item in
                item.backButtonDisplayMode = .minimal
                item.backButtonTitle = ""   // 强制去掉标题/Force remove title
            }
        )
    }
    
    /// 隐藏返回按钮标题/Hide back button title
    /// 隐藏所有返回按钮的标题。/Hides all back button titles.
    public func navigationBackButtonTitleHidden() -> some View {
        modifier(HiddenBackButtonTitlesModifier())
    }
}


extension NavigationView {
    /// 访问UINavigationController的NavigationItem并暴露到Environment中/Access the NavigationItem of the underlying `UINavigationController` and expose it in the `Environment`
    ///
    /// - Parameter animated: 传递true表示动画显示自定义；否则传递false。默认为true/Pass `true` to animate the customization; otherwise, pass `false`. Defaults to `true`
    /// - Parameter customize: 带有找到的UINavigationItem的回调/Callback with the found `UINavigationItem`
    ///
    /// 这需要在NavigationView上使用，以便能够将UINavigationController暴露给所有子视图。/This is needed on the `NavigationView` in order to be able to expose the `UINavigationController` to all subviews
    @MainActor public func navigationItem(animated: Bool = true, customize: @escaping ((UINavigationItem) -> Void)) -> some View {
        modifier(NavigationControllerModifier(animated: animated, customize: customize, forceEnvironment: true))
    }
    
    /// 暴露UINavigationController的NavigationItem到Environment中/Expose the the NavigationItem of the underlying `UINavigationController` in the `Environment`
    ///
    /// 虽然不是必须将UINavigationController暴露在Environment中，但建议这样做，因为它大大简化了查找UINavigationController的过程。
    /// While not strictly necessary to expose the the underlying `UINavigationController` in the `Environment` it is advised to do so as it heavily simplifies finding the `UINavigationController`. Without exposure accessing the NavigationItem might be slightly delayed and may cause glitches.
    ///
    /// 这需要在NavigationView上使用，以便能够将UINavigationController暴露给所有子视图。/This is needed on the `NavigationView` in order to be able to expose the `UINavigationController` to all subviews
    @MainActor public func navigationItem() -> some View {
        modifier(NavigationControllerModifier(animated: false, customize: nil, forceEnvironment: true))
    }
}

#if swift(>=5.7)
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension NavigationStack {
    /// 访问UINavigationController的NavigationItem并暴露到Environment中/Access the NavigationItem of the underlying `UINavigationController` and expose it in the `Environment`
    ///
    /// - Parameter animated: 传递true表示动画显示自定义；否则传递false。默认为true/Pass `true` to animate the customization; otherwise, pass `false`. Defaults to `true`
    /// - Parameter customize: 带有找到的UINavigationItem的回调/Callback with the found `UINavigationItem`
    ///
    /// 这需要在NavigationStack上使用，以便能够将UINavigationController暴露给所有子视图。/This is needed on the `NavigationView` in order to be able to expose the `UINavigationController` to all subviews
    public func navigationItem(animated: Bool = true, customize: @escaping ((UINavigationItem) -> Void)) -> some View {
        modifier(NavigationControllerModifier(animated: animated, customize: customize, forceEnvironment: true))
    }
    
    /// 暴露UINavigationController的NavigationItem到Environment中/Expose the the NavigationItem of the underlying `UINavigationController` in the `Environment`
    ///
    /// 虽然不是必须将UINavigationController暴露在Environment中，但建议这样做。/While not strictly necessary to expose the the underlying `UINavigationController` in the `Environment` it is advised to do so as it heavily simplifies finding the `UINavigationController`. Without exposure accessing the NavigationItem might be slightly delayed and may cause glitches.
    ///
    /// 这需要在NavigationStack上使用，以便能够将UINavigationController暴露给所有子视图。/This is needed on the `NavigationStack` in order to be able to expose the `UINavigationController` to all subviews
    public func navigationItem() -> some View {
        modifier(NavigationControllerModifier(animated: false, customize: nil, forceEnvironment: true))
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension NavigationSplitView {
    /// 访问UINavigationController的NavigationItem并暴露到Environment中/Access the NavigationItem of the underlying `UINavigationController` and expose it in the `Environment`
    ///
    /// - Parameter animated: 传递true表示动画显示自定义；否则传递false。默认为true/Pass `true` to animate the customization; otherwise, pass `false`. Defaults to `true`
    /// - Parameter customize: 带有找到的UINavigationItem的回调/Callback with the found `UINavigationItem`
    ///
    /// 这需要在NavigationSplitView上使用，以便能够将UINavigationController暴露给所有子视图。/This is needed on the `NavigationView` in order to be able to expose the `UINavigationController` to all subviews
    @MainActor public func navigationItem(animated: Bool = true, customize: @escaping ((UINavigationItem) -> Void)) -> some View {
        modifier(NavigationControllerModifier(animated: animated, customize: customize, forceEnvironment: true))
    }
    
    /// 暴露UINavigationController的NavigationItem到Environment中/Expose the the NavigationItem of the underlying `UINavigationController` in the `Environment`
    ///
    /// 虽然不是必须将UINavigationController暴露在Environment中，但建议这样做。/While not strictly necessary to expose the the underlying `UINavigationController` in the `Environment` it is advised to do so as it heavily simplifies finding the `UINavigationController`. Without exposure accessing the NavigationItem might be slightly delayed and may cause glitches.
    ///
    /// 这需要在NavigationSplitView上使用，以便能够将UINavigationController暴露给所有子视图。/This is needed on the `NavigationSplitView` in order to be able to expose the `UINavigationController` to all subviews
    @MainActor public func navigationItem() -> some View {
        modifier(NavigationControllerModifier(animated: false, customize: nil, forceEnvironment: true))
    }
}
#endif

/// 隐藏返回按钮标题修饰器/Hide back button titles modifier
struct HiddenBackButtonTitlesModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                FindNavigationController { navigationController in
                    guard let navigationController else { return }
                    applyHiddenBackButtonTitle(to: navigationController)
                }
                .frame(width: 0, height: 0)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            )
    }

    /// 应用返回按钮标题隐藏设置/Apply hidden back button title configuration
    private func applyHiddenBackButtonTitle(to navigationController: UINavigationController) {
        navigationController.viewControllers.forEach { viewController in
            applyHiddenBackButtonTitle(to: viewController.navigationItem)
        }

        if let visibleViewController = navigationController.visibleViewController {
            applyHiddenBackButtonTitle(to: visibleViewController.navigationItem)
        }
    }

    /// 隐藏单个导航项的返回按钮标题/Hide back button title for a navigation item
    private func applyHiddenBackButtonTitle(to navigationItem: UINavigationItem) {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.backButtonTitle = ""
    }
}

struct NavigationControllerModifier: ViewModifier {
    var animated: Bool
    let customize: ((UINavigationItem) -> Void)?
    var forceEnvironment = false

    @Environment(\.navigationController) var navigationController
    @State private var holder: UINavigationController?
    
    func body(content: Content) -> some View {
        if !forceEnvironment, let navigationController = navigationController {
            content
                .onAppear {
                    if navigationController.children.count == 1 {
                        // RootViewContoller is still the visibleViewController, try again delayed
                        DispatchQueue.main.async {
                            guard let viewController = navigationController.visibleViewController else { return }
                            customize(navigationItem: viewController.navigationItem)
                        }
                    } else {
                        guard let viewController = navigationController.visibleViewController else { return }
                        customize(navigationItem: viewController.navigationItem)
                    }
                }
                .animation(.default, value: forceEnvironment)
        } else {
            content
                .overlay(overlay)
                .environment(\.navigationController, holder)
        }
    }
    
    private func customize(navigationItem: UINavigationItem) {
        if animated {
            UIView.animate(withDuration: 0.35) {
                customize?(navigationItem)
            }
        } else {
            customize?(navigationItem)
        }
    }
    
    var overlay: some View {
        FindNavigationController {
            holder = $0
            customizeOverlay()
        }
        .frame(width: 0, height: 0)
        .onAppear {
            customizeOverlay()
        }
    }
    
    
    func customizeOverlay() {
        DispatchQueue.main.async {
            guard let item = holder?.children.last?.navigationItem else { return }
            customize(navigationItem: item)
        }
    }
}

struct NavigationControllerKey: EnvironmentKey {
    static var defaultValue: UINavigationController? {
        nil
    }
}

extension EnvironmentValues {
    var navigationController: UINavigationController? {
        get {
            self[NavigationControllerKey.self]
        }
        set {
            self[NavigationControllerKey.self] = newValue
        }
    }
}

struct FindNavigationController: UIViewControllerRepresentable {
    var onUpdate: (UINavigationController?) -> Void
    
    func makeUIViewController(context: Context) -> InjectViewController {
        InjectViewController()
    }
    
    func updateUIViewController(_ uiViewController: InjectViewController, context: Context) {
        DispatchQueue.main.async {
            guard let viewController = uiViewController.navigationController() else {
                print("Warning: Attempting to access navigationItem without being attached to NavigationView. Please attach `.navigationItem()` to your NavigationView or this might fail.")
                DispatchQueue.main.async {
                    onUpdate(uiViewController.navigationController())
                }
                return
            }
            
            onUpdate(viewController)
        }
    }
}

class InjectViewController: UIViewController {
    required init() {
        super.init(nibName: nil, bundle: nil)
        view = InjectView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class InjectView: UIView {
    required init() {
        super.init(frame: .zero)
        isHidden = true
        isUserInteractionEnabled = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIViewController {
    func navigationController() -> UINavigationController? {
        guard let navigationController = navigationController else {
            return siblingNavigationController()
        }
        
        return navigationController
    }
    
    private func siblingNavigationController() -> UINavigationController? {
        guard let parent = parent,
              let entryIndex = parent.children.firstIndex(of: self),
              entryIndex > 0 else {
            return nil
        }
        
        for child in parent.children[0 ..< entryIndex].reversed() {
            if let navigationController = child.findNavigationController() {
                return navigationController
            }
        }
        
        return nil
    }
    
    private func findNavigationController() -> UINavigationController? {
        for child in children {
            if let navigationController = child as? UINavigationController {
                return navigationController
            } else if let navigationController = child.findNavigationController() {
                return navigationController
            }
        }
        
        return self as? UINavigationController
    }
}
#endif
