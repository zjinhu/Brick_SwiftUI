import SwiftUI
#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
/// 自定义分段选择器/Custom segment picker
/// - ID: 段落标识类型/Segment identifier type
/// - Content: 内容视图类型/Content view type
/// - Background: 背景形状类型/Background shape type
public struct CustomSegmentPicker<ID: Identifiable, Content: View, Background: Shape>: View {
    /// 段落列表/Segment list
    let segments: [ID]
    /// 选中项绑定/Selected item binding
    @Binding var selected: ID
    /// 普通状态颜色/Normal state color
    let normalColor: Color
    /// 选中状态颜色/Selected state color
    let selectedColor: Color
    /// 选中背景颜色/Selected background color
    let selectedBackColor: Color
    /// 背景颜色/Background color
    let bgColor: Color
    /// 动画/Animation
    let animation: Animation
    /// 内容视图构建闭包/Content view build closure
    @ViewBuilder let content: (ID) -> Content
    /// 背景形状构建闭包/Background shape build closure
    @ViewBuilder let background: () -> Background
    
    @Namespace private var namespace
    
    /// 初始化自定义分段选择器/Initialize custom segment picker
    /// - Parameters:
    ///   - segments: 段落列表/Segment list
    ///   - selected: 选中项绑定/Selected item binding
    ///   - normalColor: 普通状态颜色/Normal state color
    ///   - selectedColor: 选中状态颜色/Selected state color
    ///   - selectedBackColor: 选中背景颜色/Selected background color
    ///   - bgColor: 背景颜色/Background color
    ///   - animation: 动画/Animation
    ///   - content: 内容视图构建闭包/Content view build closure
    ///   - background: 背景形状构建闭包/Background shape build closure
    public init(segments: [ID],
                selected: Binding<ID>,
                normalColor: Color = .primary,
                selectedColor: Color = .white,
                selectedBackColor: Color = .primary,
                bgColor: Color = .primary,
                animation: Animation = .default,
                content: @escaping (ID) -> Content,
                background: @escaping () -> Background) {
        self.segments = segments
        _selected = selected
        self.normalColor = normalColor
        self.selectedColor = selectedColor
        self.bgColor = bgColor
        self.selectedBackColor = selectedBackColor
        self.animation = animation
        self.content = content
        self.background = background
    }
    
    public var body: some View {
        
        GeometryReader { bounds in
            HStack(spacing: 0) {
                ForEach(segments) { segment in
                    SegmentButtonView(id: segment,
                                      selectedId: $selected,
                                      normalColor: normalColor,
                                      selectedColor: selectedColor,
                                      selectedBackColor: selectedBackColor,
                                      animation: animation,
                                      namespace: namespace) {
                        content(segment)
                    } background: {
                        background()
                    }
                    .frame(width: bounds.size.width / CGFloat(segments.count))
                    .padding(2)
                }
            }
            .background {
                background()
                    .fill(bgColor)
                    .overlay(
                        background()
                            .stroke(style: StrokeStyle(lineWidth: 1.5))
                            .foregroundColor(bgColor)
                    )
            }
        }
    }
}

/// 分段按钮视图/Segment button view (fileprivate)
fileprivate struct SegmentButtonView<ID: Identifiable, Content: View, Background: Shape> : View {
    let id: ID
    @Binding var selectedId: ID
    var normalColor: Color
    var selectedColor: Color
    var selectedBackColor: Color
    var animation: Animation
    var namespace: Namespace.ID
    @ViewBuilder var content: () -> Content
    @ViewBuilder var background: () -> Background
    
    var body: some View {
        GeometryReader { bounds in
            content()
                .frame(width: bounds.size.width, height: bounds.size.height)
                .contentShape(background())
                .clipShape(background())
                .foregroundColor(selectedId.id == id.id ? selectedColor : normalColor)
                .background(buttonBackground)
                .onTapGesture {
                    withAnimation(animation) {
                        selectedId = id
                    }
                }
        }
    }
    
    @ViewBuilder private var buttonBackground: some View {
        if selectedId.id == id.id {
            background()
                .fill(selectedBackColor)
                .matchedGeometryEffect(id: "SelectedTab", in: namespace)
        }
    }
}
#endif 
