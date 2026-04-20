//
//  Screen++.swift
//  
//  Created by 狄烨 on 2023/6/24.
//  屏幕与设备工具类 - 提供屏幕尺寸、安全区域、设备信息等 / Screen and device utility - provides screen size, safe area, device info, etc.
//  支持 iOS/macOS/watchOS 多平台 / Supports iOS/macOS/watchOS multi-platform
//

import Foundation
import SwiftUI
#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
import UIKit

// MARK: - UIWindow Extension / UIWindow 扩展

extension UIWindow {
    /// 获取当前键盘窗口 / Get current key window
    public static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .sorted { $0.activationState.sortPriority < $1.activationState.sortPriority }
            .compactMap { $0 as? UIWindowScene }
            .compactMap { $0.windows.first { $0.isKeyWindow } }
            .first
    }
}

// MARK: - UIViewController Extension / UIViewController 扩展

extension UIViewController {
    
    /// 获取窗口顶层的 UINavigationController / Get top-level UINavigationController according to the window
    public static func currentNavigationController() -> UINavigationController? {
        currentViewController()?.navigationController
    }
    
    /// 获取窗口顶层的 UIViewController / Get top-level UIViewController according to the window
    public static func currentViewController() -> UIViewController? {
        
        let vc = UIWindow.keyWindow?.rootViewController
        return getCurrentViewController(withCurrentVC: vc)
    }
    
    /// 递归获取顶层的控制器 / Get top-level controller recursively according to the controller
    private static func getCurrentViewController(withCurrentVC VC : UIViewController?) -> UIViewController? {
        
        if VC == nil {
            debugPrint("🌶： Could not find top level UIViewController")
            return nil
        }
        
        if let presentVC = VC?.presentedViewController {
            /// modal弹出的控制器 / Modal presented controller
            return getCurrentViewController(withCurrentVC: presentVC)
            
        }
        else
        if let splitVC = VC as? UISplitViewController {
            /// UISplitViewController 的根控制器 / UISplitViewController's root controller
            if splitVC.viewControllers.isEmpty {
                return VC
            }else{
                return getCurrentViewController(withCurrentVC: splitVC.viewControllers.last)
            }
        }
        else
        if let tabVC = VC as? UITabBarController {
            /// tabBar 的根控制器 / TabBar's root controller
            if let _ = tabVC.viewControllers {
                return getCurrentViewController(withCurrentVC: tabVC.selectedViewController)
            }else{
                return VC
            }
        }
        else
        if let naiVC = VC as? UINavigationController {
            /// 导航控制器 / Navigation controller
            if naiVC.viewControllers.isEmpty {
                return VC
            }else{
                return getCurrentViewController(withCurrentVC:naiVC.visibleViewController)
            }
        }
        else
        {
            /// 返回顶层控制器 / Return top controller
            return VC
        }
    }
}
// MARK: - Device Class / 设备类

/// 设备信息类 / Device information class
@MainActor
public class Device{
    /// 是否为 iPad / Whether is iPad
    public static var isIpad: Bool{
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 当前设备类型 / Current device idiom
    public static var idiom: UIUserInterfaceIdiom{
        return UIDevice.current.userInterfaceIdiom
    }
}

extension UIWindowScene {
    /// 获取当前 UIWindowScene / Get current UIWindowScene
    public static var currentWindowSence: UIWindowScene?  {
        for scene in UIApplication.shared.connectedScenes{
            if scene.activationState == .foregroundActive{
                return scene as? UIWindowScene
            }
        }
        return nil
    }
}

private extension UIScene.ActivationState {
    /// 排序优先级 / Sort priority
    var sortPriority: Int {
        switch self {
        case .foregroundActive: return 1
        case .foregroundInactive: return 2
        case .background: return 3
        case .unattached: return 4
        @unknown default: return 5
        }
    }
}

// MARK: - Screen Class / 屏幕类

/// 屏幕信息类 / Screen information class
@MainActor
public class Screen {
    /// 获取安全区域，动态计算以避免在 keyWindow 为 nil 时闪退 / Get safe area, dynamically calculated to avoid crash when keyWindow is nil
    public static var safeArea: UIEdgeInsets {
        /// 优先从当前活跃的 window scene 获取 / First get from active window scene
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first {
            return window.safeAreaInsets
        }
        
        /// 降级方案：尝试从 keyWindow 获取 / Fallback: try to get from keyWindow
        if let keyWindow = UIWindow.keyWindow {
            return keyWindow.safeAreaInsets
        }
        
        /// 最终降级：返回零值 / Final fallback: return zero
        return .zero
    }
    
    /// 导航栏高度 / Navigation bar height
    public static var navBarHeight: CGFloat {
        return UINavigationController().navigationBar.frame.size.height
    }
     
    /// TabBar 高度（含安全区域）/ TabBar height (including safe area)
    public static var tabbarHeight: CGFloat {
        return UITabBarController().tabBar.frame.size.height + safeArea.bottom
    }
    
    /// 状态栏高度 / Status bar height
    public static var statusBarHeight: CGFloat{
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.statusBarManager?.statusBarFrame.height ?? 0
        }
        return 0
    }
    
    /// 导航栏 + 状态栏 高度 / Navigation bar + status bar height
    public static var navAndStatusHeight: CGFloat {
        navBarHeight + statusBarHeight
    }
    
    /// 边框高度（1像素）/ Border height (1 pixel)
    public static let lineHeight = CGFloat(scale >= 1 ? 1/scale: 1)
    
    /// 主屏幕 / Main screen
    public static var main: UIScreen = UIScreen.main
    
    /// 屏幕缩放比例 / Screen scale
    public static var scale: CGFloat { UIScreen.main.scale}
    
    /// 当前屏幕状态 高度 / Current screen state height
    public static var realHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
    /// 当前屏幕状态 宽度 / Current screen state width
    public static var realWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    
    /// 屏幕宽度（点）/ Screen width (points)
    public static var width = UIScreen.main.bounds.width
    
    /// 屏幕高度（点）/ Screen height (points)
    public static var height = UIScreen.main.bounds.height
}

// MARK: - Platform Typealiases / 平台类型别名

/// 平台图像类型 / Platform image type
public typealias PlatformImage = UIImage
/// 平台视图类型 / Platform view type
internal typealias PlatformView = UIView
/// 平台滚动视图类型 / Platform scroll view type
internal typealias PlatformScrollView = UIScrollView
/// 平台视图控制器类型 / Platform view controller type
internal typealias PlatformViewController = UIViewController

// MARK: - UIImage Extension / UIImage 扩展

extension UIImage {
    /// 转换为 PNG 数据 / Convert to PNG data
    public var png: Data? { pngData() }
    
    /// 转换为 JPEG 数据 / Convert to JPEG data
    /// - Parameter quality: 压缩质量 (0-1) / Compression quality (0-1)
    public func jpg(quality: CGFloat) -> Data? { jpegData(compressionQuality: quality) }
}

// MARK: - CGContext Extension / CGContext 扩展

extension CGContext {
    /// 获取当前图形上下文 / Get current graphics context
    internal static var current: CGContext? {
        UIGraphicsGetCurrentContext()
    }
}
// MARK: - macOS Screen / macOS 屏幕

#elseif os(macOS)
import AppKit

/// macOS 屏幕信息类 / macOS screen information class
public class Screen {
    /// 安全区域 / Safe area
    @MainActor public static var safeArea: NSEdgeInsets = NSScreen.safeArea
    /// 主屏幕 / Main screen
    public static var main: NSScreen { NSScreen.main! }
    /// 屏幕宽度 / Screen width
    @MainActor public static var width = Screen.main.frame.size.width
    /// 屏幕高度 / Screen height
    @MainActor public static var height = Screen.main.frame.size.height
    /// 缩放比例 / Scale factor
    public static var scale: CGFloat { NSScreen.main?.backingScaleFactor ?? 1.0}
}

/// NSScreen 安全区域扩展 / NSScreen safe area extension
fileprivate extension NSScreen {
    @MainActor static var safeArea: NSEdgeInsets =
    NSApplication.shared
        .mainWindow?
        .contentView?
        .safeAreaInsets ?? .init(top: 0, left: 0, bottom: 0, right: 0)
}

/// macOS 平台类型别名 / macOS platform typealiases
public typealias PlatformImage = NSImage
internal typealias PlatformView = NSView
internal typealias PlatformScrollView = NSScrollView
internal typealias PlatformViewController = NSViewController

// MARK: - NSImage Extension / NSImage 扩展

extension NSImage {
    /// 转换为 PNG 数据 / Convert to PNG data
    public var png: Data? {
        return NSBitmapImageRep(data: tiffRepresentation!)?.representation(using: .png, properties: [:])
    }

    /// 转换为 JPEG 数据 / Convert to JPEG data
    /// - Parameter quality: 压缩质量 (0-1) / Compression quality (0-1)
    public func jpg(quality: CGFloat) -> Data? {
        return NSBitmapImageRep(data: tiffRepresentation!)?.representation(using: .jpeg, properties: [.compressionFactor: quality])
    }
}

// MARK: - CGContext Extension / CGContext 扩展

extension CGContext {
    /// 获取当前图形上下文 / Get current graphics context
    internal static var current: CGContext? {
        NSGraphicsContext.current?.cgContext
    }
}
// MARK: - watchOS Screen / watchOS 屏幕

#elseif os(watchOS)

/// watchOS 屏幕信息类 / watchOS screen information class
public class Screen {
    /// 主设备 / Main device
    public static var main: WKInterfaceDevice { WKInterfaceDevice.current() }
    /// 缩放比例 / Scale factor
    public static var scale: CGFloat { WKInterfaceDevice.current().screenScale }
    /// 屏幕宽度 / Screen width
    public static var width = main.screenBounds.size.width
    /// 屏幕高度 / Screen height
    public static var height = main.screenBounds.size.height
}

#endif

// MARK: - Platform ViewController Extension / 平台视图控制器扩展

#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)

/// 视图控制器遍历扩展 / View controller traversal extension
internal extension PlatformViewController {
    /// 获取父类型控制器 / Get ancestor controller of type
    func ancestor<ControllerType: PlatformViewController>(ofType type: ControllerType.Type) -> ControllerType? {
        var controller = parent
        while let c = controller {
            if let typed = c as? ControllerType {
                return typed
            }
            controller = c.parent
        }
        return nil
    }

    /// 获取同层级类型控制器 / Get sibling controller of type
    func sibling<ControllerType: PlatformViewController>(ofType type: ControllerType.Type) -> ControllerType? {
        guard let controller = parent, let index = controller.children.firstIndex(of: self) else { return nil }

        var children = controller.children
        children.remove(at: index)

        for c in children.reversed() {
            if let typed = c as? ControllerType {
                return typed
            } else if let typed = c.descendent(ofType: type) {
                return typed
            }
        }

        return nil
    }

    /// 获取子类型控制器 / Get descendent controller of type
    func descendent<ControllerType: PlatformViewController>(ofType type: ControllerType.Type) -> ControllerType? {
        for c in children {
            if let typed = c as? ControllerType {
                return typed
            } else if let typed = c.descendent(ofType: type) {
                return typed
            }
        }

        return nil
    }
}

// MARK: - Platform View Extension / 平台视图扩展

/// 视图遍历扩展 / View traversal extension
internal extension PlatformView {
    /// 获取父类型视图 / Get ancestor view of type
    func ancestor<ViewType: PlatformView>(ofType type: ViewType.Type) -> ViewType? {
        var view = superview
        while let s = view {
            if let typed = s as? ViewType {
                return typed
            }
            view = s.superview
        }
        return nil
    }

    /// 获取同层级类型视图 / Get sibling view of type
    func sibling<ViewType: PlatformView>(ofType type: ViewType.Type) -> ViewType? {
        guard let superview = superview, let index = superview.subviews.firstIndex(of: self) else { return nil }

        var views = superview.subviews
        views.remove(at: index)

        for subview in views.reversed() {
            if let typed = subview as? ViewType {
                return typed
            } else if let typed = subview.descendent(ofType: type) {
                return typed
            }
        }

        return nil
    }

    /// 获取子类型视图 / Get descendent view of type
    func descendent<ViewType: PlatformView>(ofType type: ViewType.Type) -> ViewType? {
        for subview in subviews {
            if let typed = subview as? ViewType {
                return typed
            } else if let typed = subview.descendent(ofType: type) {
                return typed
            }
        }

        return nil
    }

    /// 获取宿主视图 (SwiftUI 集成用) / Get host view (for SwiftUI integration)
    var host: PlatformView? {
        var view = superview
        while let s = view {
            if NSStringFromClass(type(of: s)).contains("ViewHost") {
                return s
            }
            view = s.superview
        }
        return nil
    }
}
// MARK: - Inspector / 检查器

/// 视图检查器 (用于 SwiftUI 与 UIKit 交互) / View inspector (for SwiftUI and UIKit interaction)
@MainActor 
internal struct Inspector {
    var hostView: PlatformView
    var sourceView: PlatformView
    var sourceController: PlatformViewController

    /// 查找任意匹配类型 / Find any matching type
    func `any`<ViewType: PlatformView>(ofType: ViewType.Type) -> ViewType? {
        ancestor(ofType: ViewType.self)
        ?? sibling(ofType: ViewType.self)
        ?? descendent(ofType: ViewType.self)
    }

    /// 查找父类型视图 / Find ancestor view
    func ancestor<ViewType: PlatformView>(ofType: ViewType.Type) -> ViewType? {
        hostView.ancestor(ofType: ViewType.self)
    }

    /// 查找同层级视图 / Find sibling view
    func sibling<ViewType: PlatformView>(ofType: ViewType.Type) -> ViewType? {
        hostView.sibling(ofType: ViewType.self)
    }

    /// 查找子视图 / Find descendent view
    func descendent<ViewType: PlatformView>(ofType: ViewType.Type) -> ViewType? {
        hostView.descendent(ofType: ViewType.self)
    }

    /// 查找任意匹配控制器 / Find any matching controller
    func `any`<ControllerType: PlatformViewController>(ofType: ControllerType.Type) -> ControllerType? {
        ancestor(ofType: ControllerType.self)
        ?? sibling(ofType: ControllerType.self)
        ?? descendent(ofType: ControllerType.self)
    }

    /// 查找父类型控制器 / Find ancestor controller
    func ancestor<ControllerType: PlatformViewController>(ofType: ControllerType.Type) -> ControllerType? {
        sourceController.ancestor(ofType: ControllerType.self)
    }

    /// 查找同层级控制器 / Find sibling controller
    func sibling<ControllerType: PlatformViewController>(ofType: ControllerType.Type) -> ControllerType? {
        sourceController.sibling(ofType: ControllerType.self)
    }

    /// 查找子控制器 / Find descendent controller
    func descendent<ControllerType: PlatformViewController>(ofType: ControllerType.Type) -> ControllerType? {
        sourceController.descendent(ofType: ControllerType.self)
    }
}

/// 代理结构体 / Proxy structure
internal struct Proxy<T> {
    let inspector: Inspector
    let instance: T
}

// MARK: - View Extension (SwiftUI Inspection) / View 扩展 (SwiftUI 检查)

/// View 遍历扩展 (用于 SwiftUI 与 UIKit 交互) / View traversal extension (for SwiftUI and UIKit interaction)
extension View {
    private func inject<Wrapped>(_ wrapped: Wrapped) -> some View where Wrapped: View {
        overlay(wrapped.frame(width: 0, height: 0))
    }

    /// 查找任意匹配类型的视图 / Find any view of matching type
    func `any`<T: PlatformView>(forType type: T.Type, body: @escaping (Proxy<T>) -> Void) -> some View {
        inject(InspectionView { inspector in
            inspector.any(ofType: T.self)
        } customize: { proxy in
            body(proxy)
        })
    }

    /// 查找父类型视图 / Find ancestor view
    func ancestor<T: PlatformView>(forType type: T.Type, body: @escaping (Proxy<T>) -> Void) -> some View {
        inject(InspectionView { inspector in
            inspector.ancestor(ofType: T.self)
        } customize: { proxy in
            body(proxy)
        })
    }

    /// 查找同层级视图 / Find sibling view
    func sibling<T: PlatformView>(forType type: T.Type, body: @escaping (Proxy<T>) -> Void) -> some View {
        inject(InspectionView { inspector in
            inspector.sibling(ofType: T.self)
        } customize: { proxy in
            body(proxy)
        })
    }

    /// 查找子视图 / Find descendent view
    func descendent<T: PlatformView>(forType type: T.Type, body: @escaping (Proxy<T>) -> Void) -> some View {
        inject(InspectionView { inspector in
            inspector.descendent(ofType: T.self)
        } customize: { proxy in
            body(proxy)
        })
    }

    /// 查找任意匹配类型的控制器 / Find any controller of matching type
    func `any`<T: PlatformViewController>(forType type: T.Type, body: @escaping (Proxy<T>) -> Void) -> some View {
        inject(InspectionView { inspector in
            inspector.any(ofType: T.self)
        } customize: { proxy in
            body(proxy)
        })
    }

    /// 查找父类型控制器 / Find ancestor controller
    func ancestor<T: PlatformViewController>(forType type: T.Type, body: @escaping (Proxy<T>) -> Void) -> some View {
        inject(InspectionView { inspector in
            inspector.ancestor(ofType: T.self)
        } customize: { proxy in
            body(proxy)
        })
    }

    /// 查找同层级控制器 / Find sibling controller
    func sibling<T: PlatformViewController>(forType type: T.Type, body: @escaping (Proxy<T>) -> Void) -> some View {
        inject(InspectionView { inspector in
            inspector.sibling(ofType: T.self)
        } customize: { proxy in
            body(proxy)
        })
    }

    /// 查找子控制器 / Find descendent controller
    func descendent<T: PlatformViewController>(forType type: T.Type, body: @escaping (Proxy<T>) -> Void) -> some View {
        inject(InspectionView { inspector in
            inspector.descendent(ofType: T.self)
        } customize: { proxy in
            body(proxy)
        })
    }
}

/// 检查视图 / Inspection view
private struct InspectionView<T>: View {
    let selector: (Inspector) -> T?
    let customize: (Proxy<T>) -> Void

    var body: some View {
        Representable(parent: self)
    }
}

/// 源视图 (用于检查的隐藏视图) / Source view (hidden view for inspection)
private class SourceView: PlatformView {
    required init() {
        super.init(frame: .zero)
        isHidden = true
#if os(iOS)
        isUserInteractionEnabled = false
#endif
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

// MARK: - iOS/macOS Catalyst Representable / iOS/macOS Catalyst 可表示

#if os(iOS) || targetEnvironment(macCatalyst)
private extension InspectionView {
    /// UIKit 可表示封装器 / UIKit representable wrapper
    struct Representable: UIViewRepresentable {
        let parent: InspectionView

        func makeUIView(context: Context) -> UIView { .init() }
        func updateUIView(_ view: UIView, context: Context) {
            DispatchQueue.main.async {
                guard let host = view.host else { return }

                let inspector = Inspector(
                    hostView: host,
                    sourceView: view,
                    sourceController: view.parentController
                    ?? view.window?.rootViewController
                    ?? UIViewController()
                )

                guard let target = parent.selector(inspector) else { return }
                parent.customize(.init(inspector: inspector, instance: target))
            }
        }
    }
}
#elseif os(macOS)
private extension InspectionView {
    /// AppKit 可表示封装器 / AppKit representable wrapper
    struct Representable: NSViewRepresentable {
        let parent: InspectionView

        func makeNSView(context: Context) -> NSView {
            .init(frame: .zero)
        }

        func updateNSView(_ view: NSView, context: Context) {
            DispatchQueue.main.async {
                guard let host = view.host else { return }

                let inspector = Inspector(
                    hostView: host,
                    sourceView: view,
                    sourceController: view.parentController ?? NSViewController(nibName: nil, bundle: nil)
                )

                guard let target = parent.selector(inspector) else { return }
                parent.customize(.init(inspector: inspector, instance: target))
            }
        }
    }
}
#endif
