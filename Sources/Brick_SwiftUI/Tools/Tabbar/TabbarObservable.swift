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

public enum TabbarVisible: CaseIterable {
 
    case visible
    case hidden
 
    public mutating func toggle() {
        switch self {
        case .visible:
            self = .hidden
        case .hidden:
            self = .visible
        }
    }
}
