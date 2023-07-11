//
//  CustomTabbarView.swift
//  BrickBrickDemo
//
//  Created by 狄烨 on 2023/7/11.
//

import SwiftUI
import Brick_SwiftUI
struct CustomTabbarView: View {
    @State private var tabSelection: Tab = .home
    var body: some View {
        Tabbar(selection: $tabSelection) {
            
            Color.yellow
            .tabBarItem(tab: Tab.home, selection: $tabSelection)
            
            Color.white
                .tabBarItem(tab: Tab.game, selection: $tabSelection)
            
            Color.green
                .tabBarItem(tab: Tab.apps, selection: $tabSelection)
            
            Color.orange
                .tabBarItem(tab: Tab.movie, selection: $tabSelection)
        }
        .tabBarStyle(.bar)
        .tabBarItemStyle(.horizontal)
        .tabBarIndicatorHidden(false)
        .tabBarShape(Capsule())
        .tabBarColor(.white)
        .tabBarShadow(color: .black, radius: 5, x: 0, y: 5)
        .tabBarHeight(30)
        .tabBarInPadding(5)
        .tabBarHorizontalPadding(20)
        .tabBarBottomPadding(30)
        .ss.tabBar(.hidden)
    }
}

struct CustomTabbarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabbarView()
    }
}

enum Tab: Int, Tabable{
    
    case home, game, apps, movie
    
    var icon: Image {
        switch self {
        case .home:
            return Image(symbol: .houseFill)
        case .game:
            return Image(symbol: .gamecontrollerFill)
        case .apps:
            return Image(symbol: .squareStack3dUpFill)
        case .movie:
            return Image(symbol: ._4kTv)
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .game:
            return "Games"
        case .apps:
            return "Apps"
        case .movie:
            return "Movies"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return .red
        case .game:
            return .pink
        case .apps:
            return .orange
        case .movie:
            return .purple
        }
    }
}

