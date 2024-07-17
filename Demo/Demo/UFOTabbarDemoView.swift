//
//  FourthView.swift
//  BrickBrickDemo
//
//  Created by FunWidget on 2024/7/16.
//

import SwiftUI
import BrickKit

struct UFOTabView: View {
    let title: String
    var body: some View {
        ZStack{
            Color.random()
            Text(title)
        }
        .maxWidth(.infinity)
        .maxHeight(.infinity)
    }
}

struct UFOTabbarDemoView: View {
    @State var selectTab: Tab = .home
    var body: some View {
        ZStack(alignment: .bottom){
            switch selectTab {
            case .home:
                UFOTabView(title: "home")
            case .card:
                UFOTabView(title: "card")
            case .fav:
                UFOTabView(title: "fav")
            case .pro:
                UFOTabView(title: "pro")
            case .noti:
                UFOTabView(title: "noti")
            }
            
            UFOTabBar(selectTab: $selectTab)
                .padding(.bottom)
        }
        .ignoresSafeArea()
        
    }
}

struct UFOTabBar: View {
    @Binding var selectTab: Tab
    @State var offset: CGFloat = 0*70
    @State var isShow = true
    var flashing = true
    var body: some View {
        VStack{
            ZStack{
                HStack(spacing: 0){
                    
                    ForEach(tabItems) { item in
 
                        Image(symbol: item.icon)
                            .font(.system(size: 26, weight: .bold))
                            .maxWidth(.infinity)
                            .foregroundStyle(.gray)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    selectTab = item.tab
                                    offset = CGFloat(item.tab.rawValue*72)
                                }
                            }
     
                    }
      
                }
                .height(70)
                .maxWidth(.infinity)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                }
                .overlay(alignment: .topLeading) {
                    VStack(spacing: 0){
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.yellow)
                            .height(4)
                            .width(50)
                        LightView()
                            .height(70)
                            .opacity(isShow ? 1 : 0)
                    }
                    .offset(x: 12, y: 0)
                    .offset(x: offset)
                }
                
                HStack(spacing: 0){
                    
                    ForEach(tabItems) { item in
 
                        Image(symbol: item.icon)
                            .font(.system(size: 26, weight: .bold))
                            .maxWidth(.infinity)
                            .foregroundStyle(LinearGradient(colors: [.yellow, .yellow.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                            .opacity(isShow ? 1 : 0)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    selectTab = item.tab
                                    offset = CGFloat(item.tab.rawValue*72)
                                }
                                if flashing{
                                    lightFlash()
                                }
                            }
     
                    }
      
                }
                .height(70)
                .maxWidth(.infinity)
                .mask {
                    VStack(spacing: 0){
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.yellow)
                            .height(4)
                            .width(50)
                        LightView()
                            .height(70)
                    }
                    .offset(x: 12, y: 0)
                    .offset(x: offset)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            .padding(.horizontal)
        }
    }
    
    func lightFlash(){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
            isShow.toggle()
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                isShow.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                    isShow.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                        isShow.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                            isShow.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.1){
                                isShow.toggle()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
 
    UFOTabbarDemoView()
 
}

enum Tab: Int{
    case home
    case card
    case fav
    case pro
    case noti
}
struct Tabbar: Identifiable{
    let id = UUID()
    let tab: Tab
    let icon: SFSymbolName
}

let tabItems = [
    Tabbar(tab: .home, icon: .house),
    Tabbar(tab: .card, icon: .magnifyingglass),
    Tabbar(tab: .fav, icon: .star),
    Tabbar(tab: .pro, icon: .squareStack),
    Tabbar(tab: .noti, icon: .person)
]


struct LightView: View {
    var body: some View {
        LineShape()
            .width(50)
            .height(150)
            .foregroundStyle(LinearGradient(stops: [.init(color: .yellow, location: 0.3),
                                               .init(color: .clear, location: 0.64)],
                                       startPoint: .top,
                                       endPoint: .bottom))
            .overlay(alignment: .bottom) {
                Rectangle()
                    .width(50)
                    .height(25)
                    .offset(y: -46)
                    .foregroundStyle(LinearGradient(colors: [.clear, .black.opacity(0.1), .black.opacity(0.1)], startPoint: .top, endPoint: .bottom))
                    .blur(radius: 4)
            }
        
    }
}

struct LineShape: Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 12, y: 40))
        path.addLine(to: CGPoint(x: 38, y: 40))
        path.addLine(to: CGPoint(x: 50, y: 100))
        path.addLine(to: CGPoint(x: 0.5, y: 100))
        return path
    }
}

#Preview("LineShape") {
    LightView()
}





@available(iOS 17.0, *)
struct ScrollTransition {
    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea()
            ScrollView(.horizontal) {
                HStack{
                    ForEach(0..<10) { index in
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.thinMaterial)
                            .frame(width: 300, height: 500)
                            .scrollTransition(.interactive.animation(.smooth).threshold(.visible(2))) { view, phase in
                                view
                                    .rotation3DEffect(.degrees(-12), axis: (x: 0, y: 1, z: 0), perspective: 0.8)
                                    .scaleEffect(scale(phase:phase), anchor: .leading)
                            }
                            .zIndex(-Double(index))
                    }
                }
            }
            .scrollClipDisabled()
        }
    }
    
    func scale(phase: ScrollTransitionPhase) -> CGFloat {
        switch phase {
        case .topLeading:
            1.1
        case .identity:
            1
        case .bottomTrailing:
            0.6
        }
    }
}
