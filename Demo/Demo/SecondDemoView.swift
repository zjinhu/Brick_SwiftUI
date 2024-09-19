//
//  SecondDemoView.swift
//  BrickBrickDemo
//
//  Created by FunWidget on 2024/7/10.
//

import SwiftUI
import BrickKit
@available(tvOS 16.0, *)
struct SecondDemoView: View {
    var floatingButtons: [FloatingButtonItem] = [
        .init(iconSystemName: "sparkles", action: {}),
        .init(iconSystemName: "headphones", action: {}),
        .init(iconSystemName: "wifi", action: {}),
        .init(iconSystemName: "case.fill", action: {})
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue, Color.green]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).ignoresSafeArea()
            
            
            FloatingButton(items: floatingButtons)
        }
    }
}
@available(tvOS 16.0, *)
#Preview {
    SecondDemoView()
}
 
struct FloatingButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .foregroundColor(.white)
            .padding(12)
            .contentShape(.circle)
            .background(.black)
            .clipShape(Circle())
    }
}

extension Image {
    func floatingButtonStyle() -> some View {
            modifier(FloatingButtonStyle())
    }
}

struct FloatingButtonItem: Identifiable {
    private(set) var id: UUID = .init()
    var iconSystemName: String
    var action: () -> Void
}

@available(tvOS 16.0, *)
struct FloatingButton: View {
    let items: [FloatingButtonItem]
    let buttonGap: CGFloat = 30
    let buttonSize: CGFloat = 35
    
    @State var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            if isExpanded {
                Color.black.opacity(0.3)
                    .onTapGesture {
                        isExpanded = false
                    }
                    .ignoresSafeArea()
            }

            GeometryReader{ geometry in
                buttonView
                    .position(x: geometry.frame(in: .local).maxX - 45,
                              y: geometry.frame(in: .local).maxY - 30)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isExpanded)
    }
    
    @ViewBuilder
    var buttonView: some View {
        ZStack {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Image(systemName: item.iconSystemName)
                    .floatingButtonStyle()
                    .opacity(isExpanded ? 1 : 0)
                    .offset(x: isExpanded ? offsetX(index: index) : 0, y: isExpanded ? -(buttonSize + buttonGap) : 0)
                    .animation(.easeInOut(duration: 0.3).delay(0.05 * Double(index)), value: isExpanded)
            }
            
            Image(systemName: "plus")
                .floatingButtonStyle()
                .rotationEffect(.degrees(isExpanded ? 45 : 0))
                .animation(.easeInOut, value: isExpanded)
                .onTapGesture {
                    isExpanded.toggle()
                }
        }
        
    }
    

    
    func offsetX(index: Int) -> CGFloat {
        return -CGFloat(index) * (buttonGap + buttonSize)
    }
}

