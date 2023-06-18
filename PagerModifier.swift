//
//  TabModifier.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2023/6/18.
//

import SwiftUI

extension View {

    /// Sets the navigation bar item associated with this page.
    ///
    /// - Parameter pagerTabView: The navigation bar item to associate with this page.
    public func pagerTabItem<TagType, V>(tag: TagType, @ViewBuilder _ pagerTabView: @escaping () -> V) -> some View where TagType: Hashable, V: View {
        return self.modifier(PagerTabItemModifier<TagType, V>(tag: tag, navTabView: pagerTabView))
    }

    /// Sets the style for the pager view within the the current environment.
    ///
    /// - Parameter style: The style to apply to this pager view.
    public func pagerTabStripViewStyle(_ style: PagerStyle) -> some View {
        return self.environment(\.pagerStyle, style)
    }
}

struct PagerTabItemModifier<SelectionType, NavTabView>: ViewModifier where SelectionType: Hashable, NavTabView: View {

    let navTabView: () -> NavTabView
    let tag: SelectionType

    init(tag: SelectionType, navTabView: @escaping () -> NavTabView) {
        self.tag = tag
        self.navTabView = navTabView
    }

    @MainActor func body(content: Content) -> some View {
        GeometryReader { geometryProxy in
            content
                .onAppear {
                    let frame = geometryProxy.frame(in: .named("PagerViewScrollView"))
                    index = Int(round(frame.minX / frame.width))
                    pagerSettings.createOrUpdate(tag: tag, index: index, view: navTabView())
                }.onDisappear {
                    pagerSettings.remove(tag: tag)
                }
                .onChange(of: geometryProxy.frame(in: .named("PagerViewScrollView"))) { newFrame in
                    index = Int(round(newFrame.minX / newFrame.width))
                }
                .onChange(of: index) { newIndex in
                    pagerSettings.createOrUpdate(tag: tag, index: newIndex, view: navTabView())
                }
        }
    }

    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
    @State private var index = -1
}

struct NavBarModifier<SelectionType>: ViewModifier where SelectionType: Hashable {
    @Binding private var selection: SelectionType

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !style.placedInToolbar {
                NavBarWrapperView(selection: $selection)
                content
            } else {
                content.toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        NavBarWrapperView(selection: $selection)
                    }
                })
            }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}

private struct NavBarWrapperView<SelectionType>: View where SelectionType: Hashable {
    @Binding var selection: SelectionType

    @MainActor var body: some View {
 
            if let indicatorStyle = style as? BarButtonStyle, indicatorStyle.scrollable {
                ScrollableNavBarView(selection: $selection)
            } else {
                FixedSizeNavBarView(selection: $selection)
            }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}

internal struct ScrollableNavBarView<SelectionType>: View where SelectionType: Hashable {

    @Binding var selection: SelectionType
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
    @Environment(\.pagerStyle) private var style: PagerStyle
    @State private var appeared = false

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        if let internalStyle = style as? BarButtonStyle {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    ScrollableNavBarViewLayout(spacing: internalStyle.tabItemSpacing) {
                        ForEach(pagerSettings.itemsOrderedByIndex, id: \.self) { tag in
                            NavBarItem(id: tag, selection: $selection)
                                .tag(tag)
                        }
                        internalStyle.indicatorView()
                            .frame(height: internalStyle.indicatorViewHeight)
                            .layoutValue(key: PagerWidth.self, value: pagerSettings.width)
                            .layoutValue(key: PagerOffset.self, value: pagerSettings.contentOffset)
                            .animation(appeared ? .default : .none, value: pagerSettings.contentOffset)
                    }
                    .frame(height: internalStyle.tabItemHeight)
                }
                .background(internalStyle.barBackgroundView())
                .padding(internalStyle.padding)
                .onChange(of: pagerSettings.itemsOrderedByIndex) { _ in
                    if pagerSettings.items[selection] != nil {
                        proxy.scrollTo(selection, anchor: .center)
                    }
                }
                .onChange(of: selection) { newSelection in
                    withAnimation {
                        if pagerSettings.items[newSelection] != nil {
                            proxy.scrollTo(newSelection, anchor: .center)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if pagerSettings.items[selection] != nil {
                            proxy.scrollTo(selection, anchor: .center)
                        }
                        appeared = true
                    }
                }
                .onDisappear {
                    appeared = false
                }
            }
        }
    }
}

struct ScrollableNavBarViewLayout: Layout {

    private let spacing: CGFloat

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        // Calculate and return the size of the layout container.
        var tabBarIndices = subviews.indices
        let indicatorIndex = tabBarIndices.removeLast()
        let tabBarViews = subviews[tabBarIndices]
        let indicatorSubview = subviews[indicatorIndex]

        let subviewSize = tabBarViews.map { $0.sizeThatFits(.unspecified) }
        let maxHeight = subviewSize.map { $0.height }.reduce(CGFloat.zero) { max($0, $1) }
        let fullSpacing = tabBarViews.count > 1 ?  CGFloat(tabBarViews.count - 1) * self.spacing : CGFloat.zero
        let height = proposal.replacingUnspecifiedDimensions().height
        return CGSize(width: subviewSize.map { $0.width }.reduce(0, +) + fullSpacing,
                      height: max(height, maxHeight + indicatorSubview.sizeThatFits(.unspecified).height))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var tabBarIndices = subviews.indices
        let indicatorIndex = tabBarIndices.removeLast()
        let tabBarViews = subviews[tabBarIndices]
        let indicatorSubview = subviews[indicatorIndex]
        let indicatorViewSize =  indicatorSubview.sizeThatFits(.unspecified)

        if tabBarViews.count == 0 { return }
        let subviewSize = tabBarViews.map { $0.sizeThatFits(.unspecified) }
        let maxHeight = subviewSize.map { $0.height }.reduce(CGFloat.zero, max)
        var x = bounds.minX
        var itemsFrames = [CGRect]()

        for index in tabBarIndices.indices {
            let spacing = index < tabBarIndices.indices.last! ? self.spacing : CGFloat.zero
            let subview = subviews[index]
            x += subviewSize[index].width / 2
            let point = CGPoint(x: x, y: bounds.midY - (indicatorViewSize.height / 2))
            let proposedSize = ProposedViewSize(width: subviewSize[index].width, height: maxHeight)
            subview.place(at: point, anchor: .center, proposal: proposedSize)
            itemsFrames.append(CGRect(origin: point, size: CGSize(width: proposedSize.width!, height: proposedSize.height!)))
            x += subviewSize[index].width / 2 + spacing
        }

        let contentOffset = -indicatorSubview[PagerOffset.self]
        let itemsCount = tabBarViews.count
        let pagerWidth = indicatorSubview[PagerWidth.self]
        let indexAndPercentage = contentOffset / pagerWidth
        let percentage = (indexAndPercentage + 1).truncatingRemainder(dividingBy: 1)
        let lowIndex = floor(indexAndPercentage)
        guard lowIndex < CGFloat(itemsCount) else {
            indicatorSubview.place(at: CGPoint(x: 0, y: bounds.maxY - (indicatorViewSize.height / 2)),
                                   anchor: .center,
                                   proposal: ProposedViewSize.zero)
            return
        }
        let currentWidth = itemsFrames[max(0, Int(lowIndex))].size.width
        let nextWidth = itemsFrames[min(itemsCount - 1, Int(lowIndex + 1))].size.width
        let currentPosition = lowIndex >= 0 ? itemsFrames[Int(lowIndex)].origin.x : itemsFrames[0].origin.x - currentWidth
        let nextPosition = lowIndex + 1 < CGFloat(itemsCount - 1)
            ? itemsFrames[Int(lowIndex + 1)].origin.x
            : itemsFrames[Int(itemsCount - 1)].origin.x + nextWidth
        let proposedWidth = currentWidth + ((nextWidth - currentWidth) * percentage)
        let proposedPosition = currentPosition + ((nextPosition - currentPosition) * percentage)
        indicatorSubview.place(at: CGPoint(x: proposedPosition, y: bounds.maxY - (indicatorViewSize.height / 2)),
                               anchor: .center,
                               proposal: ProposedViewSize(width: proposedWidth, height: indicatorViewSize.height))
    }

}

struct PagerOffset: LayoutValueKey {
    static let defaultValue: CGFloat = 0
}

struct PagerWidth: LayoutValueKey {
    static let defaultValue: CGFloat = 0
}

internal struct FixedSizeNavBarView<SelectionType>: View where SelectionType: Hashable {

    @Binding private var selection: SelectionType
    @Environment(\.pagerStyle) private var style: PagerStyle
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>
    @State private var appeared = false

    public init(selection: Binding<SelectionType>) {
        self._selection = selection
    }

    @MainActor var body: some View {
        if let internalStyle = style as? BarButtonStyle {
            Group {
                FixedSizeNavBarViewLayout(spacing: internalStyle.tabItemSpacing) {
                    ForEach(pagerSettings.itemsOrderedByIndex, id: \.self) { tag in
                        NavBarItem(id: tag, selection: $selection)
                            .tag(tag)
                    }
                    internalStyle.indicatorView()
                        .frame(height: internalStyle.indicatorViewHeight)
                        .layoutValue(key: PagerOffset.self, value: pagerSettings.contentOffset)
                        .layoutValue(key: PagerWidth.self, value: pagerSettings.width)
                        .animation(appeared ? .default : .none, value: pagerSettings.contentOffset)
                }
                .frame(height: internalStyle.tabItemHeight)
                .padding(internalStyle.padding)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        appeared = true
                    }
                }
                .onDisappear {
                    appeared = false
                }
            }
            .background(internalStyle.barBackgroundView())
        }
    }

}

struct FixedSizeNavBarViewLayout: Layout {

    let spacing: CGFloat

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        // Calculate and return the size of the layout container.
        var tabsIndices = subviews.indices
        let indicatorIndex = tabsIndices.removeLast()
        let tabsViews = subviews[tabsIndices]
        let indicatorSubview = subviews[indicatorIndex]

        let tabsSize = tabsViews.map { $0.sizeThatFits(.unspecified) }
        let maxHeight = tabsSize.map { $0.height }.reduce(.zero) { max($0, $1) }
        let fullSpacing = tabsViews.count > 1 ?  CGFloat(tabsViews.count - 1) * self.spacing : CGFloat.zero
        let height = proposal.replacingUnspecifiedDimensions().height
        let width = proposal.replacingUnspecifiedDimensions().width
        let size = CGSize(width: max(width, tabsSize.map { $0.width }.reduce(0, +) + fullSpacing),
                          height: max(height, maxHeight + indicatorSubview.sizeThatFits(.unspecified).height))
        return size
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        // Tell each subview where to appear.
        guard subviews.count > 1 else { return }

        var tabsIndices = subviews.indices
        let indicatorIndex = tabsIndices.removeLast()
        let tabsViews = subviews[tabsIndices]
        let indicatorSubview = subviews[indicatorIndex]
        let indicatorViewSize =  indicatorSubview.sizeThatFits(.unspecified)

        let tabsSize = tabsViews.map { $0.sizeThatFits(.unspecified) }
        let totalSpacing = tabsViews.count > 1 ?  CGFloat(tabsViews.count - 1) * self.spacing : CGFloat.zero
        let maxHeight = tabsSize.map { $0.height }.reduce(CGFloat.zero) { max($0, $1) }

        let sizeProposal = ProposedViewSize(width: (proposal.width! - totalSpacing) / CGFloat(tabsViews.count), height: maxHeight)
        let fixedWidhtSubview = (proposal.width! - totalSpacing) / CGFloat(tabsViews.count)
        var x = bounds.minX + fixedWidhtSubview / 2

        for index in tabsViews.indices {
            let spacing = index < tabsViews.indices.last! ? self.spacing : CGFloat.zero
            let tabView = subviews[index]
            tabView.place(at: CGPoint(x: x, y: bounds.midY - (indicatorViewSize.height / 2)),
                          anchor: .center,
                          proposal: sizeProposal)
            x += spacing + fixedWidhtSubview
        }

        let contentOffset = -indicatorSubview[PagerOffset.self]
        let itemsCount = tabsViews.count
        let pagerWidth = indicatorSubview[PagerWidth.self]

        guard itemsCount > 0, pagerWidth > 0 else {
            indicatorSubview.place(at: CGPoint(x: 0, y: 0), proposal: .zero)
            return
        }

        let indicatorWidth = proposal.width! / CGFloat(itemsCount)
        let indicatorX =  bounds.minX + ((contentOffset * (proposal.width! / pagerWidth)) / CGFloat(itemsCount)) + (indicatorWidth / 2)
        indicatorSubview.place(at: CGPoint(x: indicatorX, y: bounds.maxY - (indicatorViewSize.height / 2)),
                               anchor: .center,
                               proposal: ProposedViewSize(width: indicatorWidth, height: indicatorViewSize.height))
    }
}

struct NavBarItem<SelectionType>: View, Identifiable where SelectionType: Hashable {

    var id: SelectionType
    @Binding private var selection: SelectionType
    @EnvironmentObject private var pagerSettings: PagerSettings<SelectionType>

    public init(id: SelectionType, selection: Binding<SelectionType>) {
        self.id = id
        self._selection = selection
    }

    @MainActor var body: some View {
        if let dataItem = pagerSettings.items[id] {
            dataItem.view
                .onTapGesture {
                    selection = id
                }
                .accessibilityAddTraits(id == selection ? [.isButton, .isSelected] : .isButton)
        }
    }
}
