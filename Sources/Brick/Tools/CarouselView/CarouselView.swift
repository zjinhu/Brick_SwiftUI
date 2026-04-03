//
//  CarouselView.swift
//  Example
//
//  Created by iOS on 2023/5/31.
//  走马灯视图/Carousel view
//  支持循环滚动、自动播放、左右两侧缩放效果/Supports loop scrolling, auto-play, and side scaling effects

import SwiftUI
/// 走马灯视图/Carousel view
/// - Data: 数据集合类型/Data collection type
/// - ID: 元素标识类型/Element identifier type
/// - Content: 视图内容类型/View content type
public struct CarouselView<Data, ID, Content> : View where Data : RandomAccessCollection, ID : Hashable, Content : View {
    
    @ObservedObject
    private var viewModel: CarouselViewModel<Data, ID>
    private let content: (Data.Element) -> Content
    
    public var body: some View {
        GeometryReader { proxy -> AnyView in
            viewModel.viewSize = proxy.size
            return AnyView(generateContent(proxy: proxy))
        }
        .clipped()
    }
    
    private func generateContent(proxy: GeometryProxy) -> some View {
        HStack(spacing: viewModel.spacing) {
            ForEach(viewModel.data, id: viewModel.dataId) {
                content($0)
                    .frame(width: viewModel.itemWidth)
                    .scaleEffect(x: viewModel.itemScaling($0), y: viewModel.itemScaling($0), anchor: .center)
            }
        }
        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
        .offset(x: viewModel.offset)
#if !os(tvOS)
        .gesture(viewModel.dragGesture)
#endif
        .animation(viewModel.offsetAnimation, value: viewModel.offset)
        .onReceive(timer: viewModel.timer, perform: viewModel.receiveTimer)
        .onReceiveAppLifeCycle(perform: viewModel.setTimerActive)
    }
}

extension CarouselView {
    
    /// 创建循环滚动banner
    /// - Parameters:
    ///   - data: 数据源
    ///   - id: 标记
    ///   - index: 指示器
    ///   - spacing: 间距
    ///   - headspace: 两边的图片展示距离
    ///   - sidesScaling: 两边缩小量
    ///   - isWrap: 是否循环
    ///   - autoScroll: 自动滚动
    ///   - canMove: 是否能拖动
    ///   - content: 闭包
    public init(_ data: Data,
                id: KeyPath<Data.Element, ID>,
                index: Binding<Int> = .constant(0),
                spacing: CGFloat = 0,
                headspace: CGFloat = 30,
                sidesScaling: CGFloat = 0.9,
                isWrap: Bool = true,
                autoScroll: CarouselAutoScroll = .inactive,
                canMove: Bool = true,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        
        self.viewModel = CarouselViewModel(data,
                                           id: id,
                                           index: index,
                                           spacing: spacing,
                                           headspace: headspace,
                                           sidesScaling: sidesScaling,
                                           isWrap: isWrap,
                                           autoScroll: autoScroll,
                                           canMove: canMove)
        self.content = content
    }
    
}

extension CarouselView where ID == Data.Element.ID, Data.Element : Identifiable {

    public init(_ data: Data,
                index: Binding<Int> = .constant(0),
                spacing: CGFloat = 0,
                headspace: CGFloat = 30,
                sidesScaling: CGFloat = 0.9,
                isWrap: Bool = true,
                autoScroll: CarouselAutoScroll = .inactive,
                canMove: Bool = true,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        
        self.viewModel = CarouselViewModel(data,
                                           index: index,
                                           spacing: spacing,
                                           headspace: headspace,
                                           sidesScaling: sidesScaling,
                                           isWrap: isWrap,
                                           autoScroll: autoScroll,
                                           canMove: canMove)
        self.content = content
    }
    
}

/// 自动滚动模式/Auto scroll mode
public enum CarouselAutoScroll {
    /// 不自动滚动/Do not auto scroll
    case inactive
    /// 自动滚动，参数为滚动间隔（秒）/Auto scroll, parameter is scroll interval (seconds)
    case active(TimeInterval)
}


public extension CarouselAutoScroll {

    /// 默认自动滚动间隔（5秒）/Default auto scroll interval (5 seconds)
    static var defaultActive: Self {
        return .active(5)
    }

    /// 是否处于激活状态/Whether it is in active state
    var isActive: Bool {
        switch self {
        case .active(let t): return t > 0
        case .inactive : return false
        }
    }

    /// 滚动间隔（秒）/Scroll interval (seconds)
    var interval: TimeInterval {
        switch self {
        case .active(let t): return t
        case .inactive : return 0
        }
    }
}
