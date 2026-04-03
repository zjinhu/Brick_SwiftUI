//
//  PageIndicator.swift
//  页面指示器/Page indicator
//
//  Created by iOS on 2023/6/30.
//

import SwiftUI

/// 页面指示器视图/Page indicator view
/// 显示当前页面位置的分页指示器/Pagination indicator showing current page position
public struct PageIndicatorView: View {
    // MARK: - 常量/Constants
    /// 间距/Spacing between indicators
    private let spacing: CGFloat
    /// 指示器高度/Indicator height
    private let height: CGFloat
    /// 当前选中指示器宽度/Width of current selected indicator
    private let currentWidth: CGFloat
    /// 指示器颜色/Indicator color
    private let color: Color
    // MARK: - 设置/Settings
    /// 总页数/Total number of pages
    private let numPages: Int
    /// 当前选中页绑定/Current selected page binding
    @Binding private var selectedIndex: Int
    
    /// 初始化页面指示器/Initialize page indicator
    /// - Parameters:
    ///   - numPages: 总页数/Total number of pages
    ///   - currentPage: 当前页码绑定/Current page binding
    ///   - height: 指示器高度/Indicator height (default: 8)
    ///   - currentWidth: 当前选中指示器宽度/Width when selected (default: 20)
    ///   - spacing: 指示器间距/Spacing between indicators (default: 15)
    ///   - color: 指示器颜色/Indicator color (default: .black)
    public init(numPages: Int,
                currentPage: Binding<Int>,
                height: CGFloat = 8,
                currentWidth: CGFloat = 20,
                spacing: CGFloat = 15,
                color: Color = .black
    ) {
        self.numPages = numPages
        self._selectedIndex = currentPage
        
        self.height = height
        self.currentWidth = currentWidth
        self.spacing = spacing
        self.color = color
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: spacing) {
                ForEach(0..<numPages, id: \.self) { index in
                    Capsule()
                        .frame(width: selectedIndex == index ? currentWidth : height, height: height)
                        .animation(.spring(), value: UUID())
                        .foregroundColor(
                            selectedIndex == index
                            ? color
                            : color.opacity(0.6)
                        )
                }
            }
        }
    }
}

struct PageIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        PageIndicatorView(numPages: 5, currentPage: .constant(2))
            .previewDisplayName("Regular")
            .previewLayout(PreviewLayout.sizeThatFits)
            .padding()
    }
}
