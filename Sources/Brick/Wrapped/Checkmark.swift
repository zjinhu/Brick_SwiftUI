import SwiftUI

/// Brick 扩展：添加复选标记
/// Brick extension: Add checkmark
public extension Brick where Wrapped: View {
    /// 添加复选标记可见性
    /// Add checkmark visibility
    /// - Parameter visibility: Visibility 可见性 / visibility
    /// - Returns: 修改后的 View / Modified View
    @MainActor func checkmark(_ visibility: Visibility) -> some View {        wrapped.modifier(
        Checkmark(visibility: visibility)
    )
    }
}

/// 复选标记视图修饰器
/// Checkmark view modifier
struct Checkmark: ViewModifier {
    let visibility: Visibility
    func body(content: Content) -> some View {
        switch visibility {
        case .visible:
            HStack {
                content
                Spacer()
                Image(symbol: .checkmark)
                    .foregroundColor(.accentColor)
                    .font(.callout.weight(.semibold))
            }
        default:
            content
        }
    }
}

#if os(iOS)
/// ToggleStyle 扩展：添加复选框样式
/// ToggleStyle extension: Add checkbox style
extension ToggleStyle where Self == CheckboxToggleStyle {
    /// 复选框样式 / Checkbox style
    public static var checkmark: CheckboxToggleStyle { CheckboxToggleStyle() }
}

/// 复选框 Toggle 样式
/// Checkbox Toggle style
public struct CheckboxToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 10){
            Image(symbol: configuration.isOn ? .checkmarkSquareFill : .square)
                .imageScale(.large)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }

            configuration.label
        }
    }
}
#endif
