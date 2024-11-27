//
//  LaunchAppView.swift
//  BrickBrickDemo
//
//  Created by FunWidget on 2024/7/16.
//

import SwiftUI
import BrickKit
struct LaunchAppView<Content: View>: View {
    @State var show = false
    @State var showHomeView = false
    let title: String
    let backgroundImage: String
    let headImage: String
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing: 0){
                ZStack(alignment: .bottom){

                    Image(headImage)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width)
                        .foregroundColor(.black)
                        .offset (y: showHomeView ? -geo.size.height : 0)
                    
                    Text(title)
                        .bold()
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                        .opacity(show ? 1 : 0)
                        .offset (y: -500)
                        .offset(y: show ? 0 : -50)
                        .scaleEffect(show ? 1 : 1.3)
                    
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .background{
                    Image(backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .scaleEffect(show ? 1 : 1.3)
                }
                
                content()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .offset (y: showHomeView ? -geo.size.height : 0)
            }
        }
        .ignoresSafeArea()
        .onAppear{
            withAnimation(.spring(duration: 2), after: 2) {
                show.toggle()
            } completion: {
                withAnimation(.linear(duration: 1)) {
                    showHomeView = true
                }
            }
 
        }
    }
}

#Preview {
    LaunchAppView(title: "BrickKit", backgroundImage: "Image_Launch_2", headImage: "Image_Launch_1"){
        Text("你的视图")
            .maxWidth(.infinity)
            .maxHeight(.infinity)
            .background(.orange)
    }
}
