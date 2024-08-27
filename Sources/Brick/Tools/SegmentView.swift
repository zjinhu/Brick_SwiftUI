//
//  SegmentControl.swift
//  AnimatedSegmentedControl
//
//  Created by Lurich on 2024/2/27.
//

import SwiftUI
 
public struct SegmentView<ID: Identifiable & Equatable, Content: View, Indicator: View>: View {
    let segments: [ID]
    @Binding var selected: ID
    var height: CGFloat = 45
    var normalColor: Color
    var selectedColor: Color
    
    @ViewBuilder let content: (ID) -> Content
    @ViewBuilder var indicator: (CGSize) -> Indicator
    
    @State private var minX: CGFloat = .zero
    @State private var excessTabWidth: CGFloat = .zero
    
    public init(segments: [ID],
         selected: Binding<ID>,
         height: CGFloat = 45,
         normalColor: Color = .primary,
         selectedColor: Color = .gray,
         content: @escaping (ID) -> Content,
         indicator: @escaping (CGSize) -> Indicator) {
        self.segments = segments
        _selected = selected
        self.height = height
        self.normalColor = normalColor
        self.selectedColor = selectedColor
        self.content = content
        self.indicator = indicator
    }
    
    public var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let containerWidthForEachTab = size.width / CGFloat(segments.count)
            
            HStack(spacing: 0) {
                ForEach(segments) { tab in
                    content(tab)
                    .foregroundColor(selected == tab ? selectedColor : normalColor)
                    .animation(.snappy, value: selected)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        if let index = segments.firstIndex(of: tab),
                            let activeIndex = segments.firstIndex(of: selected) {
                            
                            selected = tab
                            
                            withAnimation(.snappy(duration: 0.25),
                                          after: 0.25) {
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
                        if segments.first == tab {
                            GeometryReader {  geo in
                                let size = geo.size
                                indicator(size)
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
                if let index = segments.firstIndex(of: selected) {
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

extension View {
    func animate(duration: CGFloat, _ execute: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            withAnimation(.snappy(duration: duration)) {
                execute()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                continuation.resume()
            }
        }
    }
}

/// 如果不想引入太多可以用下边的方式
//                            Task {
//                                let animationTime = 0.25
//                                await animate(duration: animationTime) {
//                                    excessTabWidth = containerWidthForEachTab * CGFloat(index - activeIndex)
//                                }
//                                await animate(duration: animationTime) {
//                                    minX = containerWidthForEachTab * CGFloat(index)
//                                    excessTabWidth = 0
//                                }
//                            }
