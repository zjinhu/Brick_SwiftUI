import SwiftUI
#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
public struct CustomSegmentPicker<ID: Identifiable, Content: View, Background: Shape>: View {
    let segments: [ID]
    @Binding var selected: ID
    let normalColor: Color
    let selectedColor: Color
    let selectedBackColor: Color
    let bgColor: Color
    let animation: Animation
    @ViewBuilder let content: (ID) -> Content
    @ViewBuilder let background: () -> Background
    
    @Namespace private var namespace
    
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
