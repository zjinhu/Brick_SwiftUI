//
//  TabbarItem.swift
//  Example
//
//  Created by iOS on 2023/6/21.
//

import SwiftUI

struct TabbarItem<Selection: Tabable>: View {
    @EnvironmentObject private var selectionObject: TabbarSelection<Selection>
    
    let indicatorShape: any Shape
    let tab: Selection
    var namespace: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selectionObject.selection = tab
            }
            
        } label: {
            ZStack {
                if isSelected {
                    AnyView(indicatorShape .fill(tab.color.opacity(0.2)))
                        .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                }
                
                HStack(spacing: 10) {
                    Image(systemName: tab.icon)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(isSelected ? tab.color : .black.opacity(0.6))
                        .scaleEffect(isSelected ? 1 : 0.9)
                        .opacity(isSelected ? 1 : 0.7)
                        .padding(.leading, isSelected ? 20 : 0)
                        .padding(.horizontal, selectionObject.selection != tab ? 10 : 0)
                    
                    if isSelected {
                        Text(tab.title)
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(tab.color)
                            .padding(.trailing, 20)
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var isSelected: Bool {
        selectionObject.selection == tab
    }
}
