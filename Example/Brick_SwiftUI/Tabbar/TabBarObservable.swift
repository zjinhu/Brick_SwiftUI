//
//  TabBarSelection.swift
//  Example
//
//  Created by iOS on 2023/6/20.
//

import SwiftUI

class TabBarSelection<TabItem: Tabable>: ObservableObject {
    @Binding var selection: TabItem
    
    init(selection: Binding<TabItem>) {
        self._selection = selection
    }
}
