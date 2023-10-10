//
//  DemoView.swift
//  BrickBrickDemo
//
//  Created by 狄烨 on 2023/7/11.
//

import SwiftUI
import BrickKit
struct DemoView: View {
    @State private var showSheet = false
    
    var body: some View {
        Brick.NavigationStack {
            DemoStackView()
#if !os(xrOS) && os(iOS)
                .ss.tabBar(.hidden)
#endif
                .navigationTitle("BrickKit")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showSheet.toggle()
                        } label: {
                            Text("Sheet")
                        }
                    }
                }
                .ss.navigationDestination(for: DemoStack.self) { caseItem in
                    switch caseItem{
                    case .navigationStack:
                        NavigationStackTView()
                    case .openURLView:
                        OpenURLView()
                        
                    case .asyncImageView:
                        AsyncImageView()
                    case .scrollsView:
                        ScrollsView()
                    case .bannerView:
                        BannerView()
                    case .loading:
                        Loading()
                            .environmentObject(StateManager())
                        
                    case .refresh:
                        Refresh()
                        
                    case .tTextFieldDemoView:
                        TTextFieldDemoView()
                    case .badgeView:
                        BadgeView()
                    case .safeAreaPaddingView:
                        SafeAreaPaddingView()
                    case .presentationView:
                        if #available(iOS 14.0, macOS 11.0, tvOS 17.0, *){
                            PresentationView()
                        }
                    case .animationCompleted:
                        if #available(iOS 14.0, macOS 11.0, tvOS 16.0, watchOS 7.0, *){
                            AnimationCompleted()
                        }
                    case .scrollStackView:
                        ScrollStackView()
#if !os(xrOS) && os(iOS)
                    case .darkModelView:
                        DarkModelView()
                    case .photoPickerView:
                        PhotoPickerView()
                    case .shareLinkView:
                        ShareLinkView()
                    case .focusStateView:
                        FocusStateView()
                        
                    case .toast:
                        Toast()
                            .environmentObject(ToastManager())
                        //                case .customTabbar:
                        //                    CustomTabbarView()
#endif
                        
                    }
                }
                .sheet(isPresented: $showSheet) {
                    SwiftUIView()
                }
            //            .ss.bottomSafeAreaInset {
            //                VStack{
            //                    Button {
            //
            //                    } label: {
            //                        Text("BottomSafeAreaInset")
            //                            .frame(width: 100, height: 50)
            //                            .background {
            //                                Color.orange
            //                            }
            //                    }
            //
            //                    Spacer.height(50)
            //                }
            //            }
            
        }
        
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView()
    }
}


struct DemoStackView: View {
    
    var body: some View {
        List{
            Section {
                Brick.NavigationLink(value: DemoStack.navigationStack) {
                    Text("NavigationStack")
                }
                
                Brick.NavigationLink("OpenURL", value:  DemoStack.openURLView)
                
                
                Brick.NavigationLink("AsyncImage", value: DemoStack.asyncImageView)
                
                Brick.NavigationLink("ScrollView", value: DemoStack.scrollsView)
                
                Brick.NavigationLink("BannerView", value: DemoStack.bannerView)
                
                Brick.NavigationLink("Loading", value: DemoStack.loading)
                
                
                Brick.NavigationLink("Refresh", value: DemoStack.refresh)
            }
            
            Section {
                
                //                        NavigationLink("Quicklook", destination: QuicklookView())
                
                Brick.NavigationLink("TTextField", value: DemoStack.tTextFieldDemoView)
                
                Brick.NavigationLink("BadgeView + Tarbar", value: DemoStack.badgeView)
                
                Brick.NavigationLink("SafeAreaPadding", value: DemoStack.safeAreaPaddingView)
                
                Brick.NavigationLink("Presentation", value: DemoStack.presentationView)
                
                
                Brick.NavigationLink("AnimationCompleted", value: DemoStack.animationCompleted)
                
                Brick.NavigationLink("ScrollStackView", value: DemoStack.scrollStackView)

                
            }
            //                Brick.NavigationLink("CustomTabbar", value: DemoStack.customTabbar)
#if os(iOS) && !os(xrOS) && !os(macOS)
            
            Section {
                
                Brick.NavigationLink("DrrkModelView", value: DemoStack.darkModelView)
                
                Brick.NavigationLink("ShareLink", value: DemoStack.shareLinkView)
                
                Brick.NavigationLink("Photo", value: DemoStack.photoPickerView)
                
                Brick.NavigationLink("Toast", value: DemoStack.toast)
                
                Brick.NavigationLink("FocusState", value: DemoStack.focusStateView)
                
            }
#endif
            
        }
    }
    
    
}

struct DemoStackView_Previews: PreviewProvider {
    static var previews: some View {
        DemoStackView()
    }
}


enum DemoStack: NavigatorScreen, CaseIterable {
    case navigationStack
    case openURLView
    
    case asyncImageView
    case scrollsView
    case bannerView
    case loading
    
    case refresh
    
    case tTextFieldDemoView
    case badgeView
    case safeAreaPaddingView
    case presentationView
    case animationCompleted
    case scrollStackView

#if !os(xrOS) && os(iOS)
    case darkModelView
    case shareLinkView
    case photoPickerView
    case focusStateView
    case toast
#endif
    //    case customTabbar
}
