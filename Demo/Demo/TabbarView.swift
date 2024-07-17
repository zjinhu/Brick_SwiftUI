//
//  TabbarView.swift
//  BrickBrickDemo
//
//  Created by 狄烨 on 2023/7/11.
//

import SwiftUI
import BrickKit
struct TabbarView: View {
    @StateObject private var tabbarIndex = TabBarIndexObserver()
    
    var body: some View {
        TabView(selection: $tabbarIndex.tabSelected) {
            DemoView()
            .tabItem {
                tabItem(for: .chat)
            }
            .tag(TabBarItem.chat)
            
            SecondDemoView()
                .tabItem {
                    tabItem(for: .role)
                }
                .tag(TabBarItem.role)
            
            ThirdDemoView()
                .tabItem {
                    tabItem(for: .history)
                }
                .tag(TabBarItem.history)
            
            Color.orange
                .tabItem {
                    tabItem(for: .account)
                }
                .tag(TabBarItem.account)
        }
        .environmentObject(tabbarIndex)
    }
    
    private func tabItem(for tab: TabBarItem) -> some View {
        return VStack {
            tab == tabbarIndex.tabSelected ? tab.selectedImage : tab.normalImage
            
            Text(tab.title)
                .foregroundColor(tab == tabbarIndex.tabSelected ? .orange : .gray)
        }
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}

class TabBarIndexObserver: ObservableObject {
    @Published var tabSelected: TabBarItem = .chat
}

enum TabBarItem: Int {
    case chat
    case role
    case history
    case account
    
    var normalImage: Image {
         switch self {
        case .chat:
             return .init(symbol: .houseFill)
        case .role:
             return .init(symbol: .gamecontrollerFill)
        case .history:
             return .init(symbol: .squareStack3dUpFill)
        case .account:
             return .init(symbol: ._4kTv)
        }
    }
    
    var selectedImage: Image {
        switch self {
        case .chat:
            return .init(symbol: .house)
        case .role:
            return .init(symbol: .gamecontroller)
        case .history:
            return .init(symbol: .squareStack3dUp)
        case .account:
            return .init(symbol: ._1Square)
        }
    }
    
    var title: String {
        switch self {
        case .chat:
            return "Chat"
        case .role:
            return "AI Assistants"
        case .history:
            return "History"
        case .account:
            return "Account"
        }
    }
}

