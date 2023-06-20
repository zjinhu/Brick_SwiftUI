//
//  TabEnvironmentKey.swift
//  Example
//
//  Created by iOS on 2023/6/20.
//

import SwiftUI


public protocol Tabable: Hashable {
    var icon: String { get }
    var selectedIcon: String { get }
    var title: String { get }
}

public extension Tabable {
    var selectedIcon: String {
        return self.icon
    }
}

struct TabBarPreferenceKey<TabItem: Tabable>: PreferenceKey {
    static var defaultValue: [TabItem] {
        return .init()
    }
    
    static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]) {
        value.append(contentsOf: nextValue())
    }
}
