//
//  TabbarItemsPreferenceKey.swift
//  Example
//
//  Created by iOS on 2023/6/21.
//

import SwiftUI

struct TabBarItemsPreferenceKey<Selection: Tabable>: PreferenceKey {
    
    static var defaultValue: [Selection] {
        return .init()
    }
    
    static func reduce(value: inout [Selection], nextValue: () -> [Selection]) {
        value += nextValue()
    }
}

struct TabBarItemViewModifier<Selection: Tabable>: ViewModifier {
    let tab: Selection
    @EnvironmentObject private var selectionObject: TabbarSelection<Selection>
    
    func body(content: Content) -> some View {
        content
            .opacity(selectionObject.selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}
