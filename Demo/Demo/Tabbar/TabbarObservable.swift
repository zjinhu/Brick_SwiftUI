//
//  TabBarSelection.swift
//  Example
//
//  Created by iOS on 2023/6/20.
//

import SwiftUI

public typealias TabbarVisibility = TabVisibility<TabbarVisible>

@MainActor
public class TabVisibility<TabbarVisible>: ObservableObject {
    let visible: Binding<TabbarVisible>
    
    public var visibility: TabbarVisible {
      get { visible.wrappedValue }
      set { visible.wrappedValue = newValue }
    }
    
    init(visibility: Binding<TabbarVisible>) {
        self.visible = visibility
    }
}
