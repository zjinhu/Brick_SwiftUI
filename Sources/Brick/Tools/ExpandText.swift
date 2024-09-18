//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/18/24.
//

import SwiftUI

public struct ExpandText<Content: View, ExpandButton: View>: View {
    @State private var isCropped = true
    @State private var isShowMore = true
    @State private var fullSize: CGFloat = .zero
    
    let lineLimit: Int
    
    public typealias ButtonAction = () -> ()
    
    @ViewBuilder let contentView: () -> Content
    @ViewBuilder let moreView: (@escaping ButtonAction) -> ExpandButton
    
    let animation: Animation?
    
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
                                                        logger.debug("\(geo.size.height)")
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
                                            self.isShowMore = false
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
