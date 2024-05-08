//
//  File.swift
//  
//
//  Created by 狄烨 on 2023/9/6.
//

import Foundation
import StoreKit
import SwiftUI
public extension URL {

    static func appStoreUrl(forAppId appId: Int) -> URL? {
        URL(string: "https://itunes.apple.com/app/id\(appId)")
    }
}

#if os(iOS)
import UIKit

public extension Brick where Wrapped: View {
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    func showStoreProduct(appID: String, perform action: @escaping (Bool) -> ()) -> some View {
        wrapped.modifier(StoreProductModifier(appID: appID, action: action))
    }
}

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
    
    func showStoreProduct() {
        action(true)
        let parameters = [SKStoreProductParameterITunesItemIdentifier: appID]
        let storeProductViewController = SKStoreProductViewController()
        storeProductViewController.loadProduct(withParameters: parameters) { status, error in
            if status {
                let viewController = UIWindow.keyWindow?.rootViewController
                viewController?.present(storeProductViewController, animated: true, completion: {
                    action(false)
                })
            } else {
                guard let error = error else { return }
                logger.log(error.localizedDescription)
            }
        }
    }
}
#endif
