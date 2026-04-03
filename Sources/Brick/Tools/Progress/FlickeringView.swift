//
//  FlickeringView.swift
//  闪烁视图/Flickering animation view
//
//  Created by iOS on 2023/7/10.
//

import SwiftUI

/// 闪烁视图/Flickering animation view
/// 显示多个围绕中心旋转并闪烁的元素/Displays multiple elements rotating around center with flickering animation
public struct FlickeringView: View {

    /// 元素数量/Number of elements
    private let count: Int
    
    /// 初始化闪烁视图/Initialize flickering view
    /// - Parameter count: 元素数量/Number of elements
    public init(count: Int) {
        self.count = count
    }

    public var body: some View {
        GeometryReader { geometry in
            ForEach(0..<count, id: \.self) { index in
                FlickeringItemView(index: index, count: count, size: geometry.size)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

/// 闪烁元素视图/Flickering item view
struct FlickeringItemView: View {
    /// 索引/Index
    let index: Int
    /// 总数/Total count
    let count: Int
    /// 尺寸/Size
    let size: CGSize

    /// 缩放比例/Scale factor
    @State private var scale: CGFloat = 0
    /// 不透明度/Opacity
    @State private var opacity: Double = 0

    var body: some View {
        let duration = 0.5
        let itemSize = size.height / 5
        let angle = 2 * CGFloat.pi / CGFloat(count) * CGFloat(index)
        let x = (size.width / 2 - itemSize / 2) * cos(angle)
        let y = (size.height / 2 - itemSize / 2) * sin(angle)

        let animation = Animation.linear(duration: duration)
            .repeatForever(autoreverses: true)
            .delay(duration * Double(index) / Double(count) * 2)

        return Circle()
            .frame(width: itemSize, height: itemSize)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                scale = 1
                opacity = 1
                withAnimation(animation) {
                    scale = 0.5
                    opacity = 0.3
                }
            }
            .offset(x: x, y: y)
    }
}
