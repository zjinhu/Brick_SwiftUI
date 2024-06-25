//
//  GeometryDemo.swift
//  BrickBrickDemo
//
//  Created by FunWidget on 2024/6/25.
//

import SwiftUI

struct GeometryDemo: View {
    @State var height: CGFloat?
    
    var body: some View {
        VStack{
            Rectangle()
                .foregroundColor(.orange)
                .frame(height: 300)
                .ss.onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.size.height / 3 // transform
                } action: {
                    self.height = $0 // do logic
                }
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .foregroundColor(.red)
                        .frame(height: height)
                        .offset(y: -100)
                }
            
            HStack {
                Text("Hello")
                    .font(.title)
                    .border(.gray)
                
                if #available(iOS 17.0, *) {
                    Text("Hello")
                        .font(.title)
                        .visualEffect { content, proxy in
                            content
                                .offset(x: proxy.size.width / 2.0, y: proxy.size.height / 2.0)
                                .scaleEffect(0.5)
                        }
                        .border(.gray)
                }  
                
                Text("Hello")
                    .font(.title)
                    .ss.visualEffect { content, proxy in
                        content
                            .offset(x: proxy.size.width / 2.0, y: proxy.size.height / 2.0)
                            .scaleEffect(0.5)
                    }
                    .border(.gray)
            }
        }
        
    }
}

#Preview {
    GeometryDemo()
}
