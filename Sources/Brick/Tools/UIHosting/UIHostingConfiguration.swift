import SwiftUI
#if os(iOS) || os(tvOS)
import UIKit
/// UIHosting配置组件（iOS 15+）/UIHosting configuration component (iOS 15+)
/// 用于在UICollectionViewCell或UITableViewCell中托管SwiftUI视图层级/Used to host a hierarchy of SwiftUI views in a UICollectionViewCell or UITableViewCell
@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension Brick where Wrapped == Any {
    
    /**
     适用于托管SwiftUI视图层级的内容配置/Suitable for hosting a hierarchy of SwiftUI views.
     使用符合UIContentConfiguration协议的值与UICollectionViewCell或UITableViewCell配合使用，分别在集合或表格视图中托管SwiftUI视图层级。/Use a value of this type, which conforms to the UIContentConfiguration protocol, with a UICollectionViewCell or UITableViewCell to host a hierarchy of SwiftUI views.
     
     以下示例在单元格中显示包含图像和文本的堆栈：/The following shows a stack with an image and text inside the cell:
     
     myCell.contentConfiguration = UIHostingConfiguration {
     HStack {
     Image(systemName: "star").foregroundStyle(.purple)
     Text("Favorites")
     Spacer()
     }
     }
     
     您还可以自定义包含单元格的背景。以下示例绘制蓝色背景：/You can also customize the background of the containing cell:
     
     myCell.contentConfiguration = UIHostingConfiguration {
     HStack {
     Image(systemName: "star").foregroundStyle(.purple)
     Text("Favorites")
     Spacer()
     }
     }
     .background {
     Color.blue
     }
     */
    /// UIHosting配置/UIHosting configuration
    /// - Label: 内容视图类型/Content view type
    /// - Background: 背景视图类型/Background view type
    public struct UIHostingConfiguration<Label: View, Background: View> {
        var content: Label
        var background: AnyView?
        var insets: ProposedInsets
        var minSize: ProposedSize
        
        /// 设置托管配置所包围单元格的背景内容/Sets the background contents for the hosting configuration's enclosing cell.
        ///
        /// 以下示例将自定义视图设置为单元格的背景：/The following example sets a custom view to the background of the cell:
        ///
        ///     UIHostingConfiguration {
        ///         Text("My Contents")
        ///     }
        ///     .background {
        ///         MyBackgroundView()
        ///     }
        ///
        /// - Parameter background: 单元格背景中显示的SwiftUI层级内容/The contents of the SwiftUI hierarchy to be shown inside the background of the cell.
        public func background<B>(@ViewBuilder background: () -> B) -> UIHostingConfiguration<Label, B> where B: View {
            .init(content: self.content, background: AnyView(background()), insets: insets, minSize: minSize)
        }
        
        /// 设置托管配置所包围单元格的背景内容/Sets the background contents for the hosting configuration's enclosing cell.
        ///
        /// 以下示例将自定义视图设置为单元格的背景：/The following example sets a custom view to the background of the cell:
        ///
        ///     UIHostingConfiguration {
        ///         Text("My Contents")
        ///     }
        ///     .background(Color.blue)
        ///
        /// - Parameter style: 用作单元格背景的形状样式/The shape style to be used as the background of the cell.
        public func background<S>(_ style: S) -> UIHostingConfiguration<Label, S> where S: ShapeStyle {
            .init(content: self.content, background: AnyView(style), insets: insets, minSize: minSize)
        }
        
        /// 初始化并返回使用此配置的内容视图的新实例/Initializes and returns a new instance of the content view using this configuration.
        @MainActor public func makeContentView() -> UIView {
            let view = UIHostingController(
                rootView: ZStack {
                    background
                    content
                },
                ignoreSafeArea: true
            ).view!
            
            view.backgroundColor = UIColor.clear
            view.clipsToBounds = false
            
            return view
        }
    }
    
}

extension Brick.UIHostingConfiguration {
    
    /// 设置配置的边距/Sets the margins around the content of the configuration.
    ///
    /// 使用此修饰器替换应用于配置根的默认边距。/Use this modifier to replace the default margins applied to the root of the configuration.
    /// 以下示例在水平边缘创建内容与背景之间的20点空间：/The following example creates 20 points of space between the content and the background on the horizontal edges.
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .margins(.horizontal, 20.0)
    ///
    /// - Parameters:
    ///    - edges: 应用插入的边缘。Any edges not specified will use the system default values. The default value is ``Edge/Set/all``.
    ///    - length: 应用的数值/The amount to apply.
    public func margins(_ edges: Edge.Set = .all, _ length: CGFloat) -> Self {
        var view = self
        if edges.contains(.leading) { view.insets.leading = length }
        if edges.contains(.trailing) { view.insets.trailing = length }
        if edges.contains(.top) { view.insets.top = length }
        if edges.contains(.bottom) { view.insets.bottom = length }
        return view
    }
    
    /// 设置配置的边距/Sets the margins around the content of the configuration.
    ///
    /// 使用此修饰器替换应用于配置根的默认边距。/Use this modifier to replace the default margins applied to the root of the configuration.
    /// 以下示例在leading边缘创建10点空间，trailing边缘创建20点空间：/The following example creates 10 points of space on the leading edge and 20 points on the trailing edge:
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .margins(.horizontal, 20.0)
    ///
    /// - Parameters:
    ///    - edges: 应用插入的边缘。Any edges not specified will use the system default values. The default value is ``Edge/Set/all``.
    ///    - insets: 应用的插入值/The insets to apply.
    public func margins(_ edges: Edge.Set = .all, _ insets: EdgeInsets) -> Self {
        var view = self
        if edges.contains(.leading) { view.insets.leading = insets.leading }
        if edges.contains(.trailing) { view.insets.trailing = insets.trailing }
        if edges.contains(.top) { view.insets.top = insets.top }
        if edges.contains(.bottom) { view.insets.bottom = insets.bottom }
        return view
    }
    
    /// 设置配置的最小尺寸/Sets the minimum size for the configuration.
    ///
    /// 使用此修饰器指示配置的关联单元格可以调整到特定的最小尺寸。/Use this modifier to indicate that a configuration's associated cell can be resized to a specific minimum.
    /// 以下示例允许单元格压缩到零尺寸：/The following example allows the cell to be compressed to zero size:
    ///
    ///     UIHostingConfiguration {
    ///         Text("My Contents")
    ///     }
    ///     .minSize(width: 0, height: 0)
    ///
    /// - Parameter width: 宽度维度使用的值。`nil`表示应使用系统默认值。The value to use for the width dimension. A value of `nil` indicates that the system default should be used.
    /// - Parameter height: 高度维度使用的值。`nil`表示应使用系统默认值。The value to use for the height dimension. A value of `nil` indicates that the system default should be used.
    //    public func minSize(width: CGFloat? = nil, height: CGFloat? = nil) -> Self {
    //        var view = self
    //        view.minSize = .init(width: width, height: height)
    //        return view
    //    }
    
}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, unavailable)
@available(watchOS, unavailable)
extension Brick.UIHostingConfiguration where Wrapped == Any, Background == EmptyView {
    
    /// 创建具有给定内容的托管配置/Creates a hosting configuration with the given contents.
    ///
    /// - Parameter content: 单元格中显示的SwiftUI层级内容/The contents of the SwiftUI hierarchy to be shown inside the cell.
    public init(@ViewBuilder label: () -> Label) {
        self.init(content: label(), background: nil, insets: .init(), minSize: .unspecified)
    }
}
/*
 Since UICollectionView is not designed to support SwiftUI out of the box,
 we need to use a little trick to get the SwiftUI View's to ignore safeArea
 insets, otherwise our cell's will not always layout correctly.
 */
/// UIHostingController内部扩展/UIHostingController internal extension
internal extension UIHostingController {
    convenience init(rootView: Content, ignoreSafeArea: Bool) {
        self.init(rootView: rootView)
        
        if ignoreSafeArea {
            disableSafeArea()
        }
    }
    
    func disableSafeArea() {
        guard let viewClass = object_getClass(view) else { return }
        
        let viewSubclassName = String(cString: class_getName(viewClass)).appending("_IgnoreSafeArea")
        if let viewSubclass = NSClassFromString(viewSubclassName) {
            object_setClass(view, viewSubclass)
        }
        else {
            guard let viewClassNameUtf8 = (viewSubclassName as NSString).utf8String else { return }
            guard let viewSubclass = objc_allocateClassPair(viewClass, viewClassNameUtf8, 0) else { return }
            
            if let method = class_getInstanceMethod(UIView.self, #selector(getter: UIView.safeAreaInsets)) {
                let safeAreaInsets: @convention(block) (AnyObject) -> UIEdgeInsets = { _ in
                    return .zero
                }
                class_addMethod(viewSubclass, #selector(getter: UIView.safeAreaInsets), imp_implementationWithBlock(safeAreaInsets), method_getTypeEncoding(method))
            }
            
            objc_registerClassPair(viewSubclass)
            object_setClass(view, viewSubclass)
        }
    }
}
#endif
