//
//  HeaderKey.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI
//MARK: HeaderKey
extension EnvironmentValues {
    var refreshHeaderUpdate: Refresh.HeaderUpdateKey.Value {
        get { self[Refresh.HeaderUpdateKey.self] }
        set { self[Refresh.HeaderUpdateKey.self] = newValue }
    }
}

extension Refresh {
    
    struct HeaderAnchorKey {
        static var defaultValue: Value = []
    }
    
    struct HeaderUpdateKey {
        static var defaultValue: Value = .init(enable: false)
    }
}

extension Refresh.HeaderAnchorKey: PreferenceKey {
    
    typealias Value = [Item]
    
    struct Item {
        let bounds: Anchor<CGRect>
        let refreshing: Bool
    }
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

extension Refresh.HeaderUpdateKey: EnvironmentKey {
    
    struct Value {
        let enable: Bool
        var progress: CGFloat = 0
        var refresh: Bool = false
    }
}
