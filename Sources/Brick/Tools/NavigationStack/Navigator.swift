import SwiftUI

/// 路径导航器类型别名/Path navigator type alias
/// 用于NBNavigationStack初始化时使用NBNavigationPath绑定或无绑定的情况/Used when NBNavigationStack is initialized with NBNavigationPath binding or no binding
public typealias PathNavigator = Navigator<AnyHashable>

/// 导航器/Navigator
/// 通过环境可用的对象，提供对当前路径的访问/An object available via the environment that gives access to the current path.
/// 支持符合NBScreen协议的Screen进行push和pop操作/Supports push and pop operations when `Screen` conforms to `NBScreen`
@MainActor
public class Navigator<Screen>: ObservableObject {
    var pathBinding: Binding<[Screen]>
    
    /// 当前导航路径/The current navigation path.
    public var path: [Screen] {
        get { pathBinding.wrappedValue }
        set { pathBinding.wrappedValue = newValue }
    }
    
    /// 初始化导航器/Initialize navigator
    /// - Parameter pathBinding: 路径绑定/Path binding
    public init(_ pathBinding: Binding<[Screen]>) {
        self.pathBinding = pathBinding
    }
}

/// 导航器扩展（当Screen符合NavigatorScreen协议时）/Navigator extension (when Screen conforms to NavigatorScreen)
public extension Navigator where Screen: NavigatorScreen {
    /// 通过push导航推入新屏幕/Pushes a new screen via a push navigation.
    /// - Parameter screen: 要推入的屏幕/The screen to push.
    func push(_ screen: Screen) {
        path.push(screen)
    }
    
    /// 弹出指定数量的屏幕/Pops a given number of screens off the stack.
    /// - Parameter count: 要返回的屏幕数量，默认为1/The number of screens to go back. Defaults to 1.
    func pop(_ count: Int = 1) {
        path.pop(count)
    }
    
    /// 弹出到数组中的指定索引/Pops to a given index in the array of screens.
    /// - Parameter index: 应成为栈顶的索引/The index that should become top of the stack.
    func popTo(index: Int) {
        path.popTo(index: index)
    }
    
    /// 弹出到根屏幕（索引0）/Pops to the root screen (index 0).
    func popToRoot() {
        path.popToRoot()
    }
    
    /// 弹出到满足给定条件的最顶层屏幕/Pops to the topmost (most recently pushed) screen in the stack that satisfies the given condition.
    /// - Parameter condition: 谓词，指示要弹出到的屏幕/The predicate indicating which screen to pop to.
    /// - Returns: 是否找到屏幕/A `Bool` indicating whether a screen was found.
    @discardableResult
    func popTo(where condition: (Screen) -> Bool) -> Bool {
        path.popTo(where: condition)
    }
}

/// 导航器扩展（当Screen符合NavigatorScreen和Equatable协议时）/Navigator extension (when Screen conforms to NavigatorScreen & Equatable)
public extension Navigator where Screen: NavigatorScreen & Equatable {
    /// 弹出到等于给定屏幕的最顶层屏幕/Pops to the topmost screen equal to the given screen.
    /// - Parameter screen: 要返回到的屏幕/The predicate indicating which screen to go back to.
    /// - Returns: 是否找到匹配的屏幕/A `Bool` indicating whether a matching screen was found.
    @discardableResult
    func popTo(_ screen: Screen) -> Bool {
        return path.popTo(screen)
    }
}

/// 导航器扩展（当Screen符合NavigatorScreen和Identifiable协议时）/Navigator extension (when Screen conforms to NavigatorScreen & Identifiable)
public extension Navigator where Screen: NavigatorScreen & Identifiable {
    /// 弹出到具有给定ID的最顶层可识别屏幕/Pops to the topmost identifiable screen with the given ID.
    /// - Parameter id: 要返回到的屏幕的ID/The id of the screen to goBack to.
    /// - Returns: 是否找到匹配的屏幕/A `Bool` indicating whether a matching screen was found.
    @discardableResult
    func popTo(id: Screen.ID) -> Bool {
        path.popTo(id: id)
    }
}

/// 导航器扩展（当Screen为AnyHashable时）/Navigator extension (when Screen == AnyHashable)
public extension Navigator where Screen == AnyHashable {
    /// 弹出到具有给定类型的屏幕/Pops to the topmost identifiable screen with the given type.
    /// - Parameter _: 屏幕类型/The type of the screen.
    /// - Returns: 是否找到匹配的屏幕/A `Bool` indicating whether a matching screen was found.
    @discardableResult
    func popTo<T: Hashable>(_: T.Type) -> Bool {
        popTo(where: { $0 is T })
    }
}
