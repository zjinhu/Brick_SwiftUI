import SwiftUI

#if canImport(SafariServices)
import SafariServices
#endif

/// Safari浏览器扩展/Safari browser extension
@MainActor
public extension Brick<Any>.OpenURLAction.Result {
    /// 在Safari浏览器中打开URL/Open URL in Safari browser
    /// - Parameter url: 要打开的URL/URL to open
    /// - Returns: 处理结果/Handle result
    static func safari(_ url: URL) -> Self {
#if os(macOS)
        NSWorkspace.shared.open(url)
#elseif os(iOS)
        let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        let window = scene?.windows.first { $0.isKeyWindow }
        guard let root = window?.rootViewController else {
            UIApplication.shared.open(url)
            return .handled
        }

        let controller = SFSafariViewController(url: url)
        if window?.traitCollection.horizontalSizeClass == .regular {
            controller.modalPresentationStyle = .pageSheet
        }

        root.present(controller, animated: true)
#elseif os(tvOS)
        UIApplication.shared.open(url)
#elseif os(watchOS)
        WKExtension.shared().openSystemURL(url)
#endif
        return .handled
    }

#if os(iOS) && canImport(SafariServices)
    /// 在Safari浏览器中打开URL（带配置）/Open URL in Safari browser (with configuration)
    /// - Parameters:
    ///   - url: 要打开的URL/URL to open
    ///   - configure: Safari配置闭包/Safari configuration closure
    /// - Returns: 处理结果/Handle result
    static func safari(_ url: URL, configure: (inout SafariConfiguration) -> Void) -> Self {
        let scene = UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
        let window = scene?.windows.first { $0.isKeyWindow }

        guard let root = window?.rootViewController else {
            UIApplication.shared.open(url)
            return .handled
        }

        var config = SafariConfiguration()
        configure(&config)

        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = config.barCollapsingEnabled
        configuration.entersReaderIfAvailable = config.prefersReader

        let controller = SFSafariViewController(url: url, configuration: configuration)
        controller.preferredControlTintColor = UIColor(config.tintColor)
        controller.dismissButtonStyle = config.dismissStyle.buttonStyle

        if window?.traitCollection.horizontalSizeClass == .regular {
            controller.modalPresentationStyle = .pageSheet
        }

        root.present(controller, animated: true)
        return .handled
    }

    /// Safari浏览器配置/Safari browser configuration
    struct SafariConfiguration {
        /// 关闭按钮样式/Dismiss button style
        public enum DismissStyle {
            case done       // 完成/Done
            case close      // 关闭/Close
            case cancel     // 取消/Cancel

            internal var buttonStyle: SFSafariViewController.DismissButtonStyle {
                switch self {
                case .cancel: return .cancel
                case .close: return .close
                case .done: return.done
                }
            }
        }

        /// 是否启用阅读模式/Whether to enable reader mode
        public var prefersReader: Bool = false
        /// 是否启用栏折叠/Whether to enable bar collapsing
        public var barCollapsingEnabled: Bool = true
        /// 关闭按钮样式/Dismiss button style
        public var dismissStyle: DismissStyle = .done
        /// 主题颜色/Theme color
        public var tintColor: Color = .accentColor
    }
#endif
}
 
