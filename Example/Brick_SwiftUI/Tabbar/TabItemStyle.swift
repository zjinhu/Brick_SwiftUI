//
//  TabItemStyle.swift
//  Example
//
//  Created by iOS on 2023/6/20.
//

import SwiftUI

public protocol TabItemStyle {
    associatedtype Content : View
    
    func tabItem(icon: String, title: String, isSelected: Bool) -> Content
    func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> Content
}

extension TabItemStyle {
    public func tabItem(icon: String, title: String, isSelected: Bool) -> Content {
        return self.tabItem(icon: icon, selectedIcon: icon, title: title, isSelected: isSelected)
    }
    
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> Content {
        return self.tabItem(icon: icon, title: title, isSelected: isSelected)
    }
    
    func tabItemErased(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> AnyView {
        return .init(self.tabItem(icon: icon, selectedIcon: selectedIcon, title: title, isSelected: isSelected))
    }
}

public struct AnyTabItemStyle: TabItemStyle {
    private let _makeTabItem: (String, String, String, Bool) -> AnyView
    
    public init<TabItem: TabItemStyle>(itemStyle: TabItem) {
        self._makeTabItem = itemStyle.tabItemErased(icon:selectedIcon:title:isSelected:)
    }
    
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        return self._makeTabItem(icon, selectedIcon, title, isSelected)
    }
}

public struct DefaultTabItemStyle: TabItemStyle {
    public func tabItem(icon: String, selectedIcon: String, title: String, isSelected: Bool) -> some View {
        VStack(spacing: 5.0) {
            Image(systemName: icon)
                .renderingMode(.template)
            
            Text(title)
                .font(.system(size: 10.0, weight: .medium))
        }
        .foregroundColor(isSelected ? .accentColor : .gray)
    }
}

struct RoundTabItemStyle: TabItemStyle {
    public func tabItem(icon: String, title: String, isSelected: Bool) -> some View {
        ZStack {
            if isSelected {
                Circle()
                    .foregroundColor(.blue)
                    .frame(width: 40.0, height: 40.0)
            }
            
            Image(systemName: icon)
                .foregroundColor(isSelected ? .white : Color.black)
                .frame(width: 32.0, height: 32.0)
        }
        .padding(.vertical, 8.0)
    }
    
}
