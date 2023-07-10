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

                        NavigationLink("AsyncImage", destination: AsyncImageView())
                        
                        NavigationLink("ScrollView", destination: ScrollsView())
                        
                        NavigationLink("BannerView", destination: BannerView())
                        
                        NavigationLink("Loading", destination: Loading() .environmentObject(LoadingManager()))
                        
                        NavigationLink("Toast", destination: Toast()
                            .environmentObject(ToastManager()))
                        
                        NavigationLink("Refresh", destination: Refresh())
                    }
                    
                    Section {
 
//                        NavigationLink("Quicklook", destination: QuicklookView())
                        
                        NavigationLink("TTextField", destination: TTextFieldDemoView())
                        
                        NavigationLink("BadgeView + Tarbar", destination: BadgeView())
                        
                        NavigationLink("SafeAreaPadding", destination: SafeAreaPaddingView())
                        
                        NavigationLink("Presentation", destination: PresentationView())
                        
                        
                        NavigationLink("AnimationCompleted", destination: AnimationCompleted())
                        
                        NavigationLink("ScrollStackView", destination: ScrollStackView())
#if os(iOS)
                        
                        NavigationLink("Photo", destination: PhotoPickerView())
                        
                        
                        NavigationLink("FocusState", destination: FocusStateView())
  
                        NavigationLink("DrrkModelView", destination: DarkModelView())
#endif
                    }
                    
                }
                .navigationTitle("Brick_SwiftUI") 
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
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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

