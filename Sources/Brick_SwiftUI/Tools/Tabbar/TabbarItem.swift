//
//  TabbarItem.swift
//  Example
//
//  Created by iOS on 2023/6/21.
//

import SwiftUI

struct HorizontalTabbarItem<Selection: Tabable>: View {
 
    let indicatorShape: any Shape
    @Binding var selection: Selection
    var tab: Selection
    let titleFont: Font
    let hideShape: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selection = tab
            }
        } label: {
            ZStack {
                if isSelected && !hideShape{
                    AnyView(
                        indicatorShape
                        .fill(tab.color.opacity(0.2))
                    )
                    .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                }
                
                HStack(spacing: 6) {
                    
                    tab.icon
                        .foregroundColor(isSelected ? tab.color : .black.opacity(0.6))
                        .scaleEffect(isSelected ? 1 : 0.9)
                        .opacity(isSelected ? 1 : 0.7)
                        .padding(.leading, 0)
                        .padding(.horizontal, selection != tab ? 20 : 10)
                    
                    if isSelected {
                        Text(tab.title)
                            .font(titleFont)
                            .foregroundColor(tab.color)
                            .padding(.trailing, 10)
                    }
                }
                .padding(.vertical, 10)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var isSelected: Bool {
        selection == tab
    }
}

struct VerticalTabbarItem<Selection: Tabable>: View {
 
    let indicatorShape: any Shape
    @Binding var selection: Selection
    var tab: Selection
    var namespace: Namespace.ID
    let titleFont: Font
    let hideShape: Bool
    
    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                selection = tab
            }
            
        } label: {
            ZStack {
                if isSelected && !hideShape{
                    AnyView(
                        indicatorShape
                        .fill(tab.color.opacity(0.2))
                    )
                    .matchedGeometryEffect(id: "Selected Tab", in: namespace)
                }
                
                VStack(spacing: 3) {
                    tab.icon
                    Text(tab.title)
                        .font(titleFont)
                }
                .foregroundColor(isSelected ? tab.color : .black.opacity(0.6))
                .opacity(isSelected ? 1 : 0.7)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
            }
        }
        .buttonStyle(.plain)
    }
    
    private var isSelected: Bool {
        selection == tab
    }
}
