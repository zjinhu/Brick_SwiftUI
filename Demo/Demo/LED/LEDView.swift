//
//  LEDView.swift
//  BrickBrickDemo
//
//  Created by FunWidget on 2024/7/16.
//

import SwiftUI
import BrickKit
struct LEDView: View {
    @State var show = false
    @State var textSize: CGFloat = 0
    @State var offset: CGFloat = 0
    var body: some View {
        ZStack{
            GeometryReader{ geometry in
                ///此处图片是需要格子为透明的，我做反了
                Image("OBSKGD0")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFill()
                    .width(geometry.size.width)
                    .height(geometry.size.height)
                    .foregroundStyle(.gray)
                
                Text("SwiftUI")
                    .font(.system(size: 360))
                    .foregroundStyle(.white)
                    .height(200)
                    .offset(x: offset)
                    .fixedSize()
                    .ss.onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.size.width // transform
                    } action: {
                        textSize = $0 // do logic
                    }
                    .rotationEffect(.degrees(90))
                    .position(x: geometry.size.width/2)
                    .mask {
                        Image("OBSKGD0")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFill()
                            .width(geometry.size.width)
                            .height(geometry.size.height)
                            .foregroundStyle(.gray)
                    }
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.01){
                            offset = geometry.size.height + textSize/2
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+1){
                            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) {
                                offset = -textSize/2
                            }
                        }

                    }
            }
        }
        .ignoresSafeArea()

    }
}

#Preview {
    LEDView()
}
