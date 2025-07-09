//
//  FooterKey.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI
//MARK: FooterKey
extension EnvironmentValues {
    
    var refreshFooterUpdate: Refresh.FooterUpdateKey.Value {
        get { self[Refresh.FooterUpdateKey.self] }
        set { self[Refresh.FooterUpdateKey.self] = newValue }
    }
}

extension Refresh {
    
    struct FooterAnchorKey {
        @MainActor static var defaultValue: Value = []
    }
    
    struct FooterUpdateKey {
        @MainActor static let defaultValue: Value = .init(enable: false)
    }
}

extension Refresh.FooterAnchorKey: @preconcurrency PreferenceKey {
    
    typealias Value = [Item]
    
    struct Item {
        let bounds: Anchor<CGRect>
        let preloadOffset: CGFloat
        let refreshing: Bool
    }
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

extension Refresh.FooterUpdateKey: @preconcurrency EnvironmentKey {
    
    struct Value: Equatable {
        let enable: Bool
        var refresh: Bool = false
    }
}
