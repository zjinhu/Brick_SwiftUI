//
//  StackedToast.swift
//  Brick
//
//  Created by Brick on 2026/4/23.
//  堆叠Toast组件/Stacked Toast component
//  支持连续弹出多个Toast并堆叠显示/Supports stacking multiple Toasts when triggered consecutively
//

import SwiftUI

// MARK: - ToastItem 数据模型/Toast Item Data Model

/// 类型擦除的Toast项目/Type-erased Toast item
/// 用于在队列中存储不同类型的Toast内容/Used to store different types of Toast content in the queue
@MainActor
public struct AnyToastItem: Identifiable {
    /// 唯一标识符/Unique identifier
    public let id: UUID
    /// Toast内容视图（类型擦除）/Toast content view (type-erased)
    let content: AnyView
    /// 显示位置/Display position
    let position: StackToastPosition
    /// 动画类型/Animation type
    let animation: StackToastAnimation
    /// 显示时长（秒）/Display duration (seconds)
    let duration: Double
    /// Y轴偏移量/Y-axis offset
    let offsetY: CGFloat
    /// 创建时间/Creation time
    let createdAt: Date
    
    /// 初始化类型擦除的Toast项目/Initialize type-erased Toast item
    /// - Parameters:
    ///   - content: Toast内容视图/Toast content view
    ///   - position: 显示位置/Display position
    ///   - animation: 动画类型/Animation type
    ///   - duration: 显示时长（秒）/Display duration (seconds)
    ///   - offsetY: Y轴偏移量/Y-axis offset
    init<Content: View>(
        content: Content,
        position: StackToastPosition = .top,
        animation: StackToastAnimation = .slide,
        duration: Double = 3.0,
        offsetY: CGFloat = 0
    ) {
        self.id = UUID()
        self.content = AnyView(content)
        self.position = position
        self.animation = animation
        self.duration = duration
        self.offsetY = offsetY
        self.createdAt = Date()
    }
}

// MARK: - StackedToastPosition 位置/Position

/// Toast在屏幕上的位置/Toast screen position
/// 仅表示Toast在屏幕的显示位置/Only represents where toast appears on screen
public enum StackToastPosition {
    /// 顶部显示/Display at top
    case top
    /// 底部显示/Display at bottom
    case bottom
    
    /// 对齐方式/Alignment
    var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
    
    /// 过渡边缘/Transition edge
    var edge: Edge {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

// MARK: - StackDirection 堆叠方向/Stack Direction

/// Toast堆叠方向/Toast stack direction
/// 控制多个Toast的堆叠展示方向，与屏幕位置无关/Controls visual stacking direction, independent of screen position
public enum StackDirection {
    /// 向上堆叠（旧Toast向上偏移）/Stack upward (older toasts offset upward)
    case up
    /// 向下堆叠（旧Toast向下偏移）/Stack downward (older toasts offset downward)
    case down
    
    /// 偏移方向系数/Offset direction multiplier
    var multiplier: CGFloat {
        switch self {
        case .up: return -1.0
        case .down: return 1.0
        }
    }
}

// MARK: - StackedToastAnimation 动画/Animation

/// 堆叠Toast动画类型/Stacked Toast animation type
public enum StackToastAnimation {
    /// 淡入淡出/Fade in and out
    case fade
    /// 滑动/Slide
    case slide
    /// 缩放/Scale
    case scale
}

// MARK: - ToastQueue 队列管理器/Queue Manager

/// Toast队列管理器/Toast queue manager
/// 管理多个Toast实例的显示和堆叠/Manages display and stacking of multiple Toast instances
@MainActor
public class StackToast: ObservableObject {
    /// 当前显示的Toast项目/Currently displayed Toast items
    @Published public private(set) var items: [AnyToastItem] = []
    
    /// 最大同时显示数量/Maximum number of toasts displayed simultaneously
    public var maxVisible: Int
    
    /// 默认显示位置/Default display position
    public var defaultPosition: StackToastPosition
    
    /// 默认动画类型/Default animation type
    public var defaultAnimation: StackToastAnimation
    
    /// 默认显示时长（秒）/Default display duration (seconds)
    public var defaultDuration: Double
    
    /// 自动消失计时器/Auto-dismiss timers
    private var timers: [UUID: DispatchWorkItem] = [:]
    
    /// 堆叠方向/Stack direction
    public var stackDirection: StackDirection
    
    /// 初始化Toast队列/Initialize Toast queue
    /// - Parameters:
    ///   - maxVisible: 最大同时显示数量/Maximum visible count
    ///   - position: 默认显示位置/Default position
    ///   - stackDirection: 堆叠方向/Stack direction
    ///   - animation: 默认动画类型/Default animation
    ///   - duration: 默认显示时长/Default duration
    public init(
        maxVisible: Int = 5,
        position: StackToastPosition = .top,
        stackDirection: StackDirection = .up,
        animation: StackToastAnimation = .slide,
        duration: Double = 3.0
    ) {
        self.maxVisible = maxVisible
        self.defaultPosition = position
        self.stackDirection = stackDirection
        self.defaultAnimation = animation
        self.defaultDuration = duration
    }
    
    /// 显示Toast/Show Toast
    /// - Parameters:
    ///   - position: 显示位置（默认使用队列默认值）/Display position (uses queue default)
    ///   - animation: 动画类型（默认使用队列默认值）/Animation type (uses queue default)
    ///   - duration: 显示时长（默认使用队列默认值）/Duration (uses queue default)
    ///   - offsetY: Y轴偏移量/Y-axis offset
    ///   - content: Toast内容视图构建闭包/Toast content view builder
    public func show<Content: View>(
        offsetY: CGFloat = 0,
        @ViewBuilder _ content: () -> Content
    ) {
        let item = AnyToastItem(
            content: content(),
            position: defaultPosition,
            animation: defaultAnimation,
            duration: defaultDuration,
            offsetY: offsetY
        )
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            items.append(item)
            // 超出最大数量时移除最旧的/Remove oldest when exceeding max
            trimExcessItems()
        }
        
        // 设置自动消失计时器/Set auto-dismiss timer
        scheduleAutoDismiss(for: item)
    }
    
    /// 显示文本Toast/Show text Toast
    /// - Parameters:
    ///   - text: 文本内容/Text content
    ///   - position: 显示位置/Display position
    ///   - duration: 显示时长/Duration
    public func showText(
        _ text: String
    ) {
        show() {
            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.8))
                )
        }
    }
    
    /// 手动移除指定Toast/Manually dismiss a specific Toast
    /// - Parameter id: Toast的唯一标识符/Toast's unique identifier
    public func dismiss(id: UUID) {
        timers[id]?.cancel()
        timers.removeValue(forKey: id)
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            items.removeAll { $0.id == id }
        }
    }
    
    /// 移除所有Toast/Dismiss all Toasts
    public func dismissAll() {
        timers.values.forEach { $0.cancel() }
        timers.removeAll()
        
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            items.removeAll()
        }
    }
    
    // MARK: - Private 私有方法/Private Methods
    
    /// 裁剪超出数量的Toast/Trim excess items
    /// 注意：此方法应在 withAnimation 块内调用/Note: should be called inside withAnimation block
    private func trimExcessItems() {
        while items.count > maxVisible {
            let oldest = items[0]
            timers[oldest.id]?.cancel()
            timers.removeValue(forKey: oldest.id)
            items.removeFirst()
        }
    }
    
    /// 设置自动消失计时器/Schedule auto-dismiss timer
    /// - Parameter item: Toast项目/Toast item
    private func scheduleAutoDismiss(for item: AnyToastItem) {
        guard item.duration > 0 else { return }
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.dismiss(id: item.id)
        }
        timers[item.id] = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + item.duration, execute: workItem)
    }
}

// MARK: - StackedToastModifier 视图修饰器/View Modifier

/// 堆叠Toast视图修饰器/Stacked Toast view modifier
/// 将ToastQueue中的Toast渲染为堆叠视图/Renders Toasts from ToastQueue as stacked views
struct StackToastModifier: ViewModifier {
    /// Toast队列/Toast queue
    @ObservedObject var queue: StackToast
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: queue.defaultPosition.alignment) {
                stackedToastView
            }
    }
    
    /// 堆叠Toast视图/Stacked Toast view
    @ViewBuilder
    private var stackedToastView: some View {
        ZStack(alignment: queue.defaultPosition.alignment) {
            ForEach(Array(queue.items.enumerated()), id: \.element.id) { index, item in
                let reversedIndex = queue.items.count - 1 - index
                
                ToastItemWrapper(
                    content: item.content,
                    animation: item.animation,
                    position: item.position
                )
                .offset(y: item.offsetY)
                .transition(makeTransition(for: item))
                .zIndex(Double(index))
                .scaleEffect(scaleForIndex(reversedIndex))
                .offset(y: offsetForIndex(reversedIndex))
                .opacity(opacityForIndex(reversedIndex))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: reversedIndex)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    // MARK: - 堆叠计算/Stack Calculations
    
    /// 计算缩放比例/Calculate scale for stacking
    /// - Parameter reversedIndex: 从顶部计算的索引/Index from top
    /// - Returns: 缩放比例/Scale value
    private func scaleForIndex(_ reversedIndex: Int) -> CGFloat {
        let scale = 1.0 - (CGFloat(reversedIndex) * 0.05)
        return max(scale, 0.8)
    }
    
    /// 计算偏移量/Calculate offset for stacking
    /// - Parameter reversedIndex: 从顶部计算的索引/Index from top
    /// - Returns: 偏移量/Offset value
    private func offsetForIndex(_ reversedIndex: Int) -> CGFloat {
        let offset = CGFloat(reversedIndex) * 8.0
        return offset * queue.stackDirection.multiplier
    }
    
    /// 计算透明度/Calculate opacity for stacking
    /// - Parameter reversedIndex: 从顶部计算的索引/Index from top
    /// - Returns: 透明度/Opacity value
    private func opacityForIndex(_ reversedIndex: Int) -> Double {
        let opacity = 1.0 - (Double(reversedIndex) * 0.15)
        return max(opacity, 0.4)
    }
    
    /// 创建过渡动画/Create transition
    /// 入场由 ToastItemWrapper 手动驱动（offset动画），退场由 transition 驱动/Entrance driven by ToastItemWrapper (offset animation), removal driven by transition
    /// - top: 从上向下划入，向上划出/Enter from top sliding down, exit sliding up
    /// - bottom: 从下向上划入，向下划出/Enter from bottom sliding up, exit sliding down
    /// - Parameter item: Toast项目/Toast item
    /// - Returns: 过渡动画/Transition
    private func makeTransition(for item: AnyToastItem) -> AnyTransition {
        switch item.animation {
        case .fade:
            return .asymmetric(insertion: .identity, removal: .opacity)
        case .slide:
            return .asymmetric(
                insertion: .identity,
                removal: .move(edge: item.position.edge).combined(with: .opacity)
            )
        case .scale:
            return .asymmetric(
                insertion: .identity,
                removal: .scale.combined(with: .opacity)
            )
        }
    }
}

// MARK: - ToastItemWrapper 入场动画包装/Entrance Animation Wrapper

/// Toast项目包装视图/Toast item wrapper view
/// 在overlay中 .transition(.move) 入场无效（无屏幕外空间），因此用手动offset/scale/opacity动画实现入场
/// In overlay, .transition(.move) insertion doesn't work (no off-screen space), so entrance is driven manually
private struct ToastItemWrapper: View {
    /// Toast内容/Toast content
    let content: AnyView
    /// 动画类型/Animation type
    let animation: StackToastAnimation
    /// 显示位置（决定slide方向）/Display position (determines slide direction)
    let position: StackToastPosition
    
    /// 是否已出现/Whether appeared
    @State private var appeared = false
    
    /// slide入场起始偏移量/Slide entrance start offset
    /// - top: 从上方（负值）划入/From above (negative) sliding down
    /// - bottom: 从下方（正值）划入/From below (positive) sliding up
    private var slideOffset: CGFloat {
        switch position {
        case .top: return -80
        case .bottom: return 80
        }
    }
    
    var body: some View {
        content
            .modifier(EntranceModifier(
                animation: animation,
                appeared: appeared,
                slideOffset: slideOffset
            ))
            .onAppear {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    appeared = true
                }
            }
    }
}

/// 入场动画修饰器/Entrance animation modifier
/// 根据动画类型应用对应的入场效果/Applies entrance effect based on animation type
private struct EntranceModifier: ViewModifier {
    let animation: StackToastAnimation
    let appeared: Bool
    let slideOffset: CGFloat
    
    func body(content: Content) -> some View {
        switch animation {
        case .fade:
            content
                .opacity(appeared ? 1.0 : 0)
        case .slide:
            content
                .offset(y: appeared ? 0 : slideOffset)
                .opacity(appeared ? 1.0 : 0)
        case .scale:
            content
                .scaleEffect(appeared ? 1.0 : 0.6)
                .opacity(appeared ? 1.0 : 0)
        }
    }
}

// MARK: - View 扩展/View Extension

public extension View {
    /// 添加堆叠Toast/Add stacked Toast
    /// - Parameter queue: Toast队列管理器/Toast queue manager
    /// - Returns: 应用了堆叠Toast的视图/View with stacked Toast applied
    func stackToast(_ queue: StackToast) -> some View {
        modifier(StackToastModifier(queue: queue))
    }
}
