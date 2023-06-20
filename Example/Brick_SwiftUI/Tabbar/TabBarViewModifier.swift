//
//  TabBarViewModifier.swift
//  Example
//
//  Created by iOS on 2023/6/20.
//

import SwiftUI

struct TabBarViewModifier<TabItem: Tabable>: ViewModifier {
    @EnvironmentObject private var selectionObject: TabBarSelection<TabItem>
    
    let item: TabItem
    
    func body(content: Content) -> some View {
        Group {
            if self.item == self.selectionObject.selection {
                content
            } else {
                Color.clear
            }
        }
        .preference(key: TabBarPreferenceKey.self, value: [self.item])
    }
}

extension View {

    public func tabItem<TabItem: Tabable>(for item: TabItem) -> some View {
        return self.modifier(TabBarViewModifier(item: item))
    }
}
