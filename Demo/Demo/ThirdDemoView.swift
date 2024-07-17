//
//  ThirdDemoView.swift
//  BrickBrickDemo
//
//  Created by FunWidget on 2024/7/16.
//

import SwiftUI

struct ThirdDemoView: View {
    @State var selectedSubscription: SubscriptionType?
    var body: some View {
        VStack{
            HStack{
                GradientBorderline()
                
                Borderline()
            }
            
            HStack{
                SubView(type: .monthly, selectedSubscription: $selectedSubscription)
                SubView(type: .yearly, selectedSubscription: $selectedSubscription)
            }
            
            Rectline()
        }

    }
}

#Preview {
    ThirdDemoView()
}

enum SubscriptionType{
    case monthly
    case yearly
}

struct SubView: View{
    var type: SubscriptionType
    @Binding var selectedSubscription: SubscriptionType?
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(.black)
            CircleView(show: .constant(selectedSubscription == type))
                .offset(x: 60, y: -60)
        }
        .squareFrame(sideLength: 170)
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .ss.border(selectedSubscription == type ? .blue : .clear, cornerRadius: 20, lineWidth: 3)
        .onTapGesture {
            withAnimation {
                selectedSubscription = selectedSubscription == type ? nil : type
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct CircleView: View{
    @Binding var show: Bool
    var body: some View{
        Group{
            Circle()
                .squareFrame(sideLength: show ? 500 : 30)
                .foregroundColor(.white)
            
            Image(symbol: show ? .checkmarkCircleFill : .circleFill)
                .resizable()
                .squareFrame(sideLength: 30)
                .foregroundColor(show ? .blue : .white)
//                .contentTransition(.symbolEffect)
        }
    }
}



struct Rectline: View {
    @State var Progress: CGFloat = 0
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 200, height: 230)
                .foregroundColor(.black)
            RoundedRectangle(cornerRadius: 20)
                .trim(from: 0.5 - Progress / 2, to: 0.5 + Progress / 2)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .frame(width: 227, height: 197)
                .rotationEffect(.degrees(90))
                .foregroundColor(.red)
        }
        .onTapGesture {
            withAnimation(.linear(duration: 2)) {
                if Progress == 0{
                    Progress = 1.0
                }else{
                    Progress = 0
                }
            }
        }
    }
}

struct Borderline: View {
    @State var rotation:CGFloat = 0.0
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.black)
                .frame(width: 200, height: 240)
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 130, height: 300)
                .foregroundColor(Color.blue)
                .rotationEffect(.degrees(rotation))
                .mask{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 7)
                        .frame(width: 193, height: 235)
                }
        }
        .onAppear{
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)){
                rotation = 360
            }
        }
    }
}

struct GradientBorderline: View {
    @State var rotation:CGFloat = 0.0
    
    var body: some View {
        ZStack{
 
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 200, height: 300)
                .overlay{
                    AngularGradient(gradient: Gradient(colors: [.clear,.clear,.clear,.clear, Color.blue]), center: .center, angle: .degrees(360))
                        .frame(width: 400, height: 400)
                        .rotationEffect(.degrees(rotation))
                        .mask{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 7)
                                .frame(width: 197, height: 297)
                        }
                }

        }
        .onAppear{
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)){
                rotation = 360
            }
        }
    }
}
