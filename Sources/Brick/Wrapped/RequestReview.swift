import SwiftUI
import StoreKit

#if os(iOS) || os(macOS)

/// 环境值扩展：应用商店评价请求
/// Environment values extension: App Store review request
public extension EnvironmentValues {
    
    /// An instance that tells StoreKit to request an App Store rating or review from the user, if appropriate.
    /// Read the requestReview environment value to get an instance of this structure for a given Environment. Call the instance to tell StoreKit to ask the user to rate or review your app, if appropriate. You call the instance directly because it defines a callAsFunction() method that Swift calls when you call the instance.
    ///
    /// Although you normally call this instance to request a review when it makes sense in the user experience flow of your app, the App Store policy governs the actual display of the rating and review request view. Because calling this instance may not present an alert, don’t call it in response to a user action, such as a button tap.
    ///
    /// > When you call this instance while your app is in development mode, the system always displays a rating and review request view so you can test the user interface and experience. This instance has no effect when you call it in an app that you distribute using
    /// Call the instance to tell StoreKit to ask the user to rate or review your app.
    /// Note: The App Store policy governs the actual display of the rating and review request view.
    @_disfavoredOverload
    @MainActor var requestReview: Brick<Any>.RequestReviewAction { .init() }
    
}

/// An instance that tells StoreKit to request an App Store rating or review from the user, if appropriate.
/// Read the requestReview environment value to get an instance of this structure for a given Environment. Call the instance to tell StoreKit to ask the user to rate or review your app, if appropriate. You call the instance directly because it defines a callAsFunction() method that Swift calls when you call the instance.
///
/// Although you normally call this instance to request a review when it makes sense in the user experience flow of your app, the App Store policy governs the actual display of the rating and review request view. Because calling this instance may not present an alert, don’t call it in response to a user action, such as a button tap.
///
/// > When you call this instance while your app is in development mode, the system always displays a rating and review request view so you can test the user interface and experience. This instance has no effect when you call it in an app that you distribute using TestFlight.
///
/// 应用商店评价请求动作
/// App Store review request action
/// 
/// iOS 16+ 已废弃，请使用原生 RequestReview
/// iOS 16+ deprecated, use native RequestReview
@available(iOS, deprecated: 16)
@available(macOS, deprecated: 13)
extension Brick where Wrapped == Any {
    /// 应用商店评价请求动作
    /// App Store review request action
    @MainActor public struct RequestReviewAction {
        /// 请求评价
        /// Request review
        public func callAsFunction() {
#if os(macOS)
            SKStoreReviewController.requestReview()
#else
            guard let scene = UIWindowScene.currentWindowSence else { return }
            SKStoreReviewController.requestReview(in: scene)
#endif
        }
    }
}
#endif

 
