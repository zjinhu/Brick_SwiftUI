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
#if os(iOS)
                .ss.tabBar(.visible)
                .navigationTitle("BrickKit")
                .navigationBarTitleDisplayMode(.inline)
#endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            showSheet.toggle()
                        } label: {
                            Text("Sheet SegmentView")
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
                            .environmentObject(LoadingManager())
                        
                    case .refresh:
                        Refresh()
                        
                    case .tTextFieldDemoView:
                        TTextFieldDemoView()
                    case .badgeView:
                        BadgeView()
                    case .safeAreaPaddingView:
                        SafeAreaPaddingView()
                    case .presentationView:
                        PresentationView()
                    case .animationCompleted:
                        AnimationCompleted()
                    case .scrollStackView:
                        ScrollStackView()
#if os(iOS)
                    case .darkModelView:
                        DarkModelView()
//                    case .photoPickerView:
//                        PhotoPickerView()
                    case .shareLinkView:
                        ShareLinkView()
                    case .focusStateView:
                        FocusStateView()
                        
                    case .toast:
                        Toast()
                            .environmentObject(ToastManager())
                        //                case .customTabbar:
                        //                    CustomTabbarView()
                    case .geometry:
                        GeometryDemo()
                    case .pagingScrollView:
                        PageingScrollView()
#endif
                        
                    }
                }
                .sheet(isPresented: $showSheet) {
                    SegmentStylesView()
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
                
                NavigationLink("Quicklook", destination: QuicklookView())
                
                Brick.NavigationLink("TTextField", value: DemoStack.tTextFieldDemoView)
                
                Brick.NavigationLink("BadgeView + Tarbar", value: DemoStack.badgeView)
                
                Brick.NavigationLink("SafeAreaPadding", value: DemoStack.safeAreaPaddingView)
                
                Brick.NavigationLink("Presentation", value: DemoStack.presentationView)
                
                
                Brick.NavigationLink("AnimationCompleted", value: DemoStack.animationCompleted)
                
                Brick.NavigationLink("ScrollStackView", value: DemoStack.scrollStackView)

                
            }
#if os(iOS) && !os(macOS)
            
            Section {
                
                Brick.NavigationLink("DrrkModelView", value: DemoStack.darkModelView)
                
                Brick.NavigationLink("ShareLink", value: DemoStack.shareLinkView)

                Brick.NavigationLink("Toast", value: DemoStack.toast)
                
                Brick.NavigationLink("FocusState", value: DemoStack.focusStateView)
                
                Brick.NavigationLink("GeometryDemo", value: DemoStack.geometry)
                Brick.NavigationLink("PagingScrollView", value: DemoStack.pagingScrollView)
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

#if os(iOS)
    case darkModelView
    case shareLinkView
    case focusStateView
    case toast
    case geometry
    case pagingScrollView
#endif
}
