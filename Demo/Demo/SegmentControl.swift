//
//  SegmentControl.swift
//  AnimatedSegmentedControl
//
//  Created by Lurich on 2024/2/27.
//

import SwiftUI
import BrickKit
struct SegmentControl<Indicator: View>: View {
    var tabs: [SegmentedTab]
    @Binding var activeTab: SegmentedTab
    var height: CGFloat = 45
    var displayAsText: Bool = false
    var font: Font = .title3
    var activeTint: Color
    var inActiveTint: Color
    @ViewBuilder var indicatorView: (CGSize) -> Indicator
    
    @State private var minX: CGFloat = .zero
    @State private var excessTabWidth: CGFloat = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let containerWidthForEachTab = size.width / CGFloat(tabs.count)
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.rawValue) { tab in
                    Group {
                        if displayAsText {
                            Text(tab.rawValue)
                        } else {
                            Image(systemName: tab.rawValue)
                        }
                    }
                    .font(font)
                    .foregroundColor(activeTab == tab ? activeTint : inActiveTint)
                    .animation(.snappy, value: activeTab)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        if let index = tabs.firstIndex(of: tab), let activeIndex = tabs.firstIndex(of: activeTab) {
                            activeTab = tab
                            
                            withAnimation(.snappy(duration: 0.25)) {
                                excessTabWidth = containerWidthForEachTab * CGFloat(index - activeIndex)
                            } completion: {
                                withAnimation(.snappy(duration: 0.25)) {
                                    minX = containerWidthForEachTab * CGFloat(index)
                                    excessTabWidth = 0
                                }
                            }
                            
                        }
                    }
                    .background(alignment: .leading) {
                        if tabs.first == tab {
                            GeometryReader {
                                let size = $0.size
                                indicatorView(size)
                                    .frame(width: (size.width + abs(excessTabWidth)), height: size.height)
                                    .frame(width: size.width, alignment: excessTabWidth < 0 ? .trailing : .leading)
                                    .offset(x: minX)
                            }
                        }
                    }
                }
            }
            .preference(key: SizeKey.self, value: size)
            .onPreferenceChange(SizeKey.self, perform: { value in
                if let index = tabs.firstIndex(of: activeTab) {
                    minX = containerWidthForEachTab * CGFloat(index)
                    excessTabWidth = 0
                }
            })
        }
        .frame(height: height)
    }
}

fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

#Preview {
    @State var activeTab: SegmentedTab = .home
    @State var type2: Bool = true
    
    return SegmentControl(
        tabs: SegmentedTab.allCases,
        activeTab: $activeTab,
        height: 35,
        displayAsText: false,
        font: .body,
        activeTint: type2 ? .white : .primary,
        inActiveTint: .gray.opacity(0.5)
    ) { size in
        RoundedRectangle(cornerRadius: type2 ? 30 : 0)
            .fill(.blue)
            .frame(height: type2 ? size.height : 4)
            .padding(.horizontal, type2 ? 0 : 10)
            .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .padding(.top, type2 ? 0 : 10)
    .background() {
        RoundedRectangle(cornerRadius: type2 ? 30 : 0)
            .fill(.orange)
            .ignoresSafeArea()
    }
    .padding(.horizontal, type2 ? 15 : 0)
}


enum SegmentedTab: String, CaseIterable {
    case home = "house.fill"
    case favorites = "suit.heart.fill"
    case notifications = "bell.fill"
    case profile = "person.fill"
}
