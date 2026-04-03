//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/18/24.
//

import SwiftUI
#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)

/// 展开收起文本视图/Expand text view
/// 支持限制行数显示，点击展开完整内容。/Supports line limit display, tap to expand full content.
public struct ExpandText<Content: View, ExpandButton: View>: View {
    @State private var isCropped = true
    @State private var isShowMore = true
    @State private var fullSize: CGFloat = .zero
    
    /// 限制行数/Line limit
    let lineLimit: Int
    
    /// 按钮操作类型/Button action type
    public typealias ButtonAction = () -> ()
    
    /// 内容视图构建器/Content view builder
    @ViewBuilder let contentView: () -> Content
    /// 展开按钮视图构建器/Expand button view builder
    @ViewBuilder let moreView: (@escaping ButtonAction) -> ExpandButton
    
    /// 动画/Animation
    let animation: Animation?
    
    /// 初始化展开文本视图/Initialize expand text view
    /// - Parameters:
    ///   - lineLimit: 限制行数，默认3/Line limit, default 3
    ///   - animation: 展开动画/Expand animation
    ///   - contentView: 内容视图构建器/Content view builder
    ///   - moreView: 展开按钮视图构建器/Expand button view builder
    public init(
        lineLimit: Int = 3,
        animation: Animation? = .none,
        @ViewBuilder contentView: @escaping () -> Content,
        @ViewBuilder moreView: @escaping (@escaping ButtonAction) -> ExpandButton
    ) {
        self.lineLimit = lineLimit
        self.contentView = contentView
        self.moreView = moreView
        self.animation = animation
    }
    
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            contentView()
                .lineLimit(isCropped ? lineLimit : nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    ZStack{
                        if isCropped {
                            if fullSize != 0 {
                                contentView()
                                    .lineLimit(lineLimit)
                                    .background(
                                        GeometryReader { geo in
                                            Color.clear
                                                .onAppear {
                                                    if fullSize > geo.size.height {
                                                        self.isShowMore = true
                                                    }else{
                                                        self.isShowMore = false
                                                    }
                                                }
                                        }
                                    )
                            }
                            
                            contentView()
                                .fixedSize(horizontal: false, vertical: true)
                                .background(GeometryReader { geo in
                                    Color.clear
                                        .onAppear() {
                                            self.fullSize = geo.size.height
                                        }
                                })
                        }
                    }
                        .hidden()
                )
                .onTapGesture {
                    if !isCropped{
                        isCropped.toggle()
                    }
                }
            
            if  isCropped, isShowMore{
                moreView() {
                    withAnimation(animation) {
                        isCropped = false
                    }
                }
            }
        }
    }
}

struct ExpandTextView: View {
    var body: some View {
        ExpandText(lineLimit: 2, animation: .easeInOut(duration: 0.2)) {
            Text("123123")
                .font(.title)
            +
            Text(" ")
            +
            Text("Do you think you're living an ordinary life? You are so mistaken it's difficult to even explain. The mere fact that you exist that you exist t1")
        } moreView: { action in
            Button(" ... more", action: action)
                .background(.white)
        }
        
    }
}

#Preview {
    ExpandTextView()
        .background(.orange)
}
#endif
