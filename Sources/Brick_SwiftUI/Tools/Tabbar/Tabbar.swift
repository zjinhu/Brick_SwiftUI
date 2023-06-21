
import SwiftUI

public struct Tabbar<Selection: Tabable, Content: View>: View {
    @Environment(\.tabBarForegroundView) private var tabBarForegroundView
    @Environment(\.tabBarShape) private var tabBarShape
    @Environment(\.tabBarShadow) private var tabBarShadow
    @Environment(\.tabBarColor) private var tabBarColor
    @Environment(\.tabBarInPadding) private var tabBarInPadding
    @Environment(\.tabBarHorizontalPadding) private var tabBarHorizontalPadding
    @Environment(\.tabBarBottomPadding) private var tabBarBottomPadding
    @Environment(\.tabBarHeight) private var tabBarHeight
    
    @Namespace private var namespace
    private let selection: TabbarSelection<Selection>
    @State private var items: [Selection] = []
    private let content: Content
    @State private var visibility: TabbarVisible = .visible
    
    public init(selection: Binding<Selection>,
                @ViewBuilder content: () -> Content) {
        self.selection = .init(selection: selection)
        self.content = content()
    }
    
    public var body: some View {
        ZStack{
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    HStack {
                        ForEach(items, id: \.hashValue) { tab in
                            TabbarItem(indicatorShape: anyShapeBar, tab: tab,  namespace: namespace)
                        }
                    }
                    .padding(tabBarInPadding)
                    .background(
                        GeometryReader(content: backgroundBar(with:))
                    )
                    .frame(height: tabBarHeight)
                    .padding(.horizontal, tabBarHorizontalPadding)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + tabBarBottomPadding)
                }
                .edgesIgnoringSafeArea(.bottom)
                .animation(.linear, value: visibility)
                .visibility(visibility)
                .onChange(of: visibility) { newValue in
                    withAnimation {
                        visibility = newValue
                    }
                }
            }
        }
        .environmentObject(selection)
        .environmentObject(TabbarVisibility(visibility: $visibility))
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.items = value
        }
    }
    
    private func backgroundBar(with geo: GeometryProxy) -> some View {
        filledViewBar(with: geo)
            .shadow(color: tabBarShadow.color, radius: tabBarShadow.radius, x: tabBarShadow.x, y: tabBarShadow.y)
    }
    
    @ViewBuilder
    private func filledViewBar(with geo: GeometryProxy) -> some View {
        if let tabBarForegroundView {
            AnyView(filledShapBar(with: geo)
                .foreground(tabBarForegroundView)
                .clipShape(anyShapeBar))
        } else {
            filledShapBar(with: geo)
        }
    }
 
    private func filledShapBar(with geo: GeometryProxy) -> some View {
        AnyView(anyShapeBar.fill(anyColorBar))
    }
    
    private var anyShapeBar: any Shape { tabBarShape ?? Capsule()  }
    private var anyColorBar: Color { tabBarColor ?? Color.white }
}

