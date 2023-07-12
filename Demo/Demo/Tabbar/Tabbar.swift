
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
    
    @Environment(\.tabBarStyle) private var tabBarStyle
    @Environment(\.tabBarItemStyle) private var tabBarItemStyle
    @Environment(\.tabBarFont) private var tabBarFont
    @Environment(\.tabBarIndicatorHidden) private var tabBarShapeHidden
    
    @Namespace private var namespace
    @Binding var selection: Selection
    @State private var items: [Selection] = []
    private let content: Content
    @State private var visibility: TabbarVisible = .visible
    
    public init(selection: Binding<Selection>,
                @ViewBuilder content: () -> Content) {
        self._selection = selection
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
                    
                    switch tabBarStyle{
                    case .system:
                        HStack {
                            ForEach(items, id: \.hashValue) { tab in
                                VerticalTabbarItem(indicatorShape: anyShapeBar,
                                                   selection: $selection,
                                                   tab: tab,
                                                   namespace: namespace,
                                                   titleFont: tabBarFont,
                                                   hideShape: tabBarShapeHidden)
                             }
                        }
                        .padding(.horizontal, tabBarHorizontalPadding)
                        .padding(tabBarInPadding)
                        .background(
                            tabBarColor.ignoresSafeArea(edges: .bottom)
                                .shadow(color: tabBarShadow.color, radius: tabBarShadow.radius, x: tabBarShadow.x, y: tabBarShadow.y)
                        )
                        .frame(height: tabBarHeight)
                        .padding(.bottom, geometry.safeAreaInsets.bottom + tabBarBottomPadding)
                    case .bar:
                        HStack {
                            ForEach(items, id: \.hashValue) { tab in
                                switch tabBarItemStyle{
                                case .vertical:
                                    VerticalTabbarItem(indicatorShape: anyShapeBar,
                                                       selection: $selection,
                                                       tab: tab,
                                                       namespace: namespace,
                                                       titleFont: tabBarFont,
                                                       hideShape: tabBarShapeHidden)
                                case .horizontal:
                                    HorizontalTabbarItem(indicatorShape: anyShapeBar,
                                                         selection: $selection,
                                                         tab: tab,
                                                         titleFont: tabBarFont,
                                                         hideShape: tabBarShapeHidden,
                                                         namespace: namespace)
                                }
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
                }
                .edgesIgnoringSafeArea(.bottom)
                .visibility(visibility)
            }
        }
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
 
    @ViewBuilder
    private func filledShapBar(with geo: GeometryProxy) -> some View {
        AnyView(anyShapeBar.fill(anyColorBar))
    }
    
    private var anyShapeBar: any Shape { tabBarShape ?? Capsule()  }
    private var anyColorBar: Color { tabBarColor ?? Color.white }
}

