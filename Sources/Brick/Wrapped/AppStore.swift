//
//  AppStore.swift
//  Brick_SwiftUI
//
//  App Store 相关功能扩展
//  App Store related functionality extensions
//  - 生成 App Store 链接 / Generate App Store URL
//  - 展示应用推广页面 / Present StoreKit product view
//
//  Created by 狄烨 on 2023/9/6.
//

import Foundation
import StoreKit
import SwiftUI

/// URL 扩展：生成 App Store 链接
/// URL extension: Generate App Store URL
public extension URL {
    /// 根据 App ID 生成 App Store 链接
    /// Generate App Store URL from App ID
    /// - Parameter appId: Apple App ID
    /// - Returns: App Store URL
    static func appStoreUrl(forAppId appId: Int) -> URL? {
        URL(string: "https://itunes.apple.com/app/id\(appId)")
    }
}

#if os(iOS)
import UIKit

/// Brick 扩展：展示 App Store 产品页面
/// Brick extension: Present App Store product page
@MainActor
public extension Brick where Wrapped: View {
    /// 展示应用推广页面
    /// Present StoreKit product view controller
    /// - Parameters:
    ///   - appID: Apple App ID
    ///   - action: 回调闭包 / Callback closure
    /// - Returns: 修改后的 View / Modified View
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    func showStoreProduct(appID: String, perform action: @escaping (Bool) -> ()) -> some View {
        wrapped.modifier(StoreProductModifier(appID: appID, action: action))
    }
}

/// 应用推广页面修饰器
/// Store product modifier
@available(macOS, unavailable)
@available(tvOS, unavailable)
struct StoreProductModifier: ViewModifier {
    private let appID : String
    private let action: (Bool) -> ()
    public init(appID: String, action: @escaping (Bool) -> ()) {
        self.appID = appID
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .contentShape(Rectangle())
            .onTapGesture {
                showStoreProduct()
            }
    }
    
    /// 展示 StoreKit 产品页面
    /// Present StoreKit product view
    func showStoreProduct() {
        action(true)
        let parameters = [SKStoreProductParameterITunesItemIdentifier: appID]
        let storeProductViewController = SKStoreProductViewController()
        storeProductViewController.loadProduct(withParameters: parameters) { status, error in
            if status {
                 Task { @MainActor in
                     if let viewController = UIWindow.keyWindow?.rootViewController {
                         viewController.present(storeProductViewController, animated: true) {
                             action(false)
                         }
                     }
                 }
             } else {
                 if let error = error {
                     Task { @MainActor in
                         print(error.localizedDescription)
                     }
                 }
             }
        }
    }
}
#endif
