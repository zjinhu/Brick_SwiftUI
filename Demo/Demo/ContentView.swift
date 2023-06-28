//
//  ContentView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/5/12.
//

import SwiftUI
import Brick_SwiftUI
struct ContentView: View {
    @Brick.AppStorage("START_TIME_KEY", store:UserDefaults.standard) var startTime: Date = Date()
    @State private var showSheet = false
    @State private var tabSelection: Tab = .home

    var body: some View {
        Tabbar(selection: $tabSelection) {
            
            Brick.NavigationStack {
                List{
                    Section {
                        NavigationLink("NavigationStack", destination: NavigationStackTView())
                        
                        NavigationLink("OpenURL", destination: OpenURLView())
                        
                        NavigationLink("ShareLink", destination: ShareLinkView())
                        
                        if #available(iOS 16.0, *) {
                            NavigationLink("Photo", destination: PhotoPickerView())
                        }
                        
                        NavigationLink("AsyncImage", destination: AsyncImageView())
                        
                        NavigationLink("ScrollView", destination: ScrollsView())
                        
                        NavigationLink("BannerView", destination: BannerView())
                        
                        NavigationLink("Loading", destination: Loading() .environmentObject(LoadingManager()))
                        
                        NavigationLink("Toast", destination: Toast()
                            .environmentObject(ToastManager()))
                        
                        NavigationLink("Refresh", destination: Refresh())
                    }
                    
                    Section {
                        NavigationLink("Quicklook", destination: QuicklookView())
                        
                        NavigationLink("TTextField", destination: TTextFieldDemoView())
                        
                        NavigationLink("BadgeView + Tarbar", destination: BadgeView())
                        
                        NavigationLink("SafeAreaPadding", destination: SafeAreaPaddingView())
                        
                        NavigationLink("Presentation", destination: PresentationView())
                        
                        NavigationLink("FocusState", destination: FocusStateView())
                        
                        NavigationLink("AnimationCompleted", destination: AnimationCompleted())
                        
                        NavigationLink("ScrollStackView", destination: ScrollStackView())
                        
                        NavigationLink("DrrkModelView", destination: DarkModelView())
                    }
                    
                }
                .navigationTitle("Brick_SwiftUI")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showSheet.toggle()
                        } label: {
                            Text("Sheet")
                        }
                    }
                }
                .sheet(isPresented: $showSheet) {
                    SwiftUIView()
                }
                .ss.bottomSafeAreaInset {
                    VStack{
                        Button {
                            
                        } label: {
                            Text("BottomSafeAreaInset")
                                .frame(width: 100, height: 50)
                                .background {
                                    Color.orange
                                }
                        }
                        
                        Spacer.height(50)
                    }
                    
                }
                
            }
            .tabBarItem(tab: Tab.home)
            
            Color.white
            .tabBarItem(tab: Tab.game)
            
            Color.green
                .tabBarItem(tab: Tab.apps)
            
            Color.orange
                .tabBarItem(tab: Tab.movie)
        }
        .tabBarStyle(.bar)
        .tabBarItemStyle(.vertical)
        .tabBarIndicatorHidden(false)
        .tabBarShape(RoundedRectangle(cornerRadius: 10))
        .tabBarColor(.white)
        .tabBarShadow(color: .black, radius: 5, x: 0, y: 5)
        .tabBarHeight(30)
        .tabBarInPadding(5)
        .tabBarHorizontalPadding(20)
        .tabBarBottomPadding(10)

    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum Tab: Int, Tabable{
    
    case home, game, apps, movie
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .game:
            return "gamecontroller.fill"
        case .apps:
            return "square.stack.3d.up.fill"
        case .movie:
            return "play.tv.fill"
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

