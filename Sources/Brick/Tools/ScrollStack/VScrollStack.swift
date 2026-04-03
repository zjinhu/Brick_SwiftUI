import SwiftUI

/// 尊重如 `Spacer()` 元素的可滚动垂直堆栈 / A scrollable `VStack` that respects elemnts like `Spacer()`
public struct VScrollStack<Content: View>: View {
    /// 水平对齐方式 / Horizontal alignment
    private let alignment: HorizontalAlignment
    /// 元素间距 / Spacing between elements
    private let spacing: CGFloat?
    /// 是否显示滚动指示器 / Whether to show scroll indicators
    private let showsIndicators: Bool
    /// 内容视图 / Content view
    private let content: Content
    
    /// 初始化垂直滚动堆栈 / Initialize vertical scroll stack
    /// - Parameters:
    ///   - alignment: 水平对齐方式 / Horizontal alignment (default: .center)
    ///   - spacing: 元素间距 / Spacing between elements (default: nil)
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators (default: false)
    ///   - content: 内容视图构建器 / Content view builder
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, showsIndicators: Bool = false, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            LazyVStack(alignment: alignment, spacing: spacing) {
                content
            }
        }
    }
}

/// 可滚动的垂直网格视图 / A scrollable vertical grid view
public struct VScrollGrid<Content: View>: View {
    /// 水平对齐方式 / Horizontal alignment
    private let alignment: HorizontalAlignment
    /// 元素间距 / Spacing between elements
    private let spacing: CGFloat?
    /// 是否显示滚动指示器 / Whether to show scroll indicators
    private let showsIndicators: Bool
    /// 内容视图 / Content view
    private let content: Content
    /// 列配置数组 / Columns configuration array
    private let columns: [GridItem]
    
    /// 使用行数初始化 / Initialize with rows count (backward compatible)
    /// - Parameters:
    ///   - rowsCount: 列数 / Number of columns
    ///   - alignment: 水平对齐方式 / Horizontal alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    public init(rowsCount: Int,
                alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                showsIndicators: Bool = false,
                @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
        self.columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: rowsCount)
    }
    
    /// 使用自定义 GridItem 数组初始化 / Initialize with custom GridItem array
    /// - Parameters:
    ///   - columns: 自定义列配置 / Custom columns configuration
    ///   - alignment: 水平对齐方式 / Horizontal alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    public init(columns: [GridItem],
                alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                showsIndicators: Bool = false,
                @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
        self.columns = columns
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            LazyVGrid(columns: columns,
                      alignment: alignment,
                      spacing: spacing) {
                content
            }
        }
    }
}

// MARK: - 便利扩展 / Convenience Extensions
public extension VScrollGrid {
    
    /// 创建固定宽度列的便利初始化器 / Convenience initializer for fixed width columns
    /// - Parameters:
    ///   - widths: 固定宽度数组 / Array of fixed widths
    ///   - alignment: 水平对齐方式 / Horizontal alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    /// - Returns: 垂直滚动网格 / VScrollGrid instance
    static func fixedColumns(widths: [CGFloat],
                            alignment: HorizontalAlignment = .center,
                            spacing: CGFloat? = nil,
                            showsIndicators: Bool = false,
                            @ViewBuilder content: () -> Content) -> VScrollGrid {
        let columns = widths.map { GridItem(.fixed($0), spacing: spacing) }
        return VScrollGrid(columns: columns,
                          alignment: alignment,
                          spacing: spacing,
                          showsIndicators: showsIndicators,
                          content: content)
    }
    
    /// 创建自适应列的便利初始化器 / Convenience initializer for adaptive columns
    /// - Parameters:
    ///   - minimum: 最小宽度 / Minimum width
    ///   - maximum: 最大宽度 / Maximum width
    ///   - alignment: 水平对齐方式 / Horizontal alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    /// - Returns: 垂直滚动网格 / VScrollGrid instance
    static func adaptiveColumns(minimum: CGFloat,
                               maximum: CGFloat = .infinity,
                               alignment: HorizontalAlignment = .center,
                               spacing: CGFloat? = nil,
                               showsIndicators: Bool = false,
                               @ViewBuilder content: () -> Content) -> VScrollGrid {
        let columns = [GridItem(.adaptive(minimum: minimum, maximum: maximum), spacing: spacing)]
        return VScrollGrid(columns: columns,
                          alignment: alignment,
                          spacing: spacing,
                          showsIndicators: showsIndicators,
                          content: content)
    }
    
    /// 创建混合类型列的便利初始化器 / Convenience initializer for mixed type columns
    /// - Parameters:
    ///   - flexibleCount: 灵活列数量 / Number of flexible columns
    ///   - fixedWidths: 固定宽度数组 / Array of fixed widths
    ///   - alignment: 水平对齐方式 / Horizontal alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    /// - Returns: 垂直滚动网格 / VScrollGrid instance
    static func mixedColumns(flexibleCount: Int,
                            fixedWidths: [CGFloat] = [],
                            alignment: HorizontalAlignment = .center,
                            spacing: CGFloat? = nil,
                            showsIndicators: Bool = false,
                            @ViewBuilder content: () -> Content) -> VScrollGrid {
        var columns: [GridItem] = []
        
        // 添加灵活列 / Add flexible columns
        columns.append(contentsOf: Array(repeating: GridItem(.flexible(), spacing: spacing), count: flexibleCount))
        
        // 添加固定宽度列 / Add fixed width columns
        columns.append(contentsOf: fixedWidths.map { GridItem(.fixed($0), spacing: spacing) })
        
        return VScrollGrid(columns: columns,
                          alignment: alignment,
                          spacing: spacing,
                          showsIndicators: showsIndicators,
                          content: content)
    }
}

// MARK: - 使用示例
//struct VScrollGridExamples: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            
//            // 1. 使用原有的行数初始化（向后兼容）
//            VScrollGrid(rowsCount: 3, spacing: 10) {
//                ForEach(0..<12, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.blue.opacity(0.6))
//                        .frame(height: 60)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 200)
//            
//            // 2. 使用自定义 GridItem 数组
//            VScrollGrid(columns: [
//                GridItem(.fixed(100), spacing: 5),
//                GridItem(.flexible(), spacing: 5),
//                GridItem(.fixed(80), spacing: 5)
//            ], spacing: 10) {
//                ForEach(0..<9, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.green.opacity(0.6))
//                        .frame(height: 50)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 150)
//            
//            // 3. 使用固定宽度列的便利方法
//            VScrollGrid.fixedColumns(widths: [80, 120, 80], spacing: 8) {
//                ForEach(0..<9, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.orange.opacity(0.6))
//                        .frame(height: 40)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 120)
//            
//            // 4. 使用自适应列
//            VScrollGrid.adaptiveColumns(minimum: 100, spacing: 10) {
//                ForEach(0..<15, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.purple.opacity(0.6))
//                        .frame(height: 60)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 180)
//            
//            // 5. 使用混合类型列
//            VScrollGrid.mixedColumns(flexibleCount: 2, fixedWidths: [60], spacing: 8) {
//                ForEach(0..<12, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.red.opacity(0.6))
//                        .frame(height: 45)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 140)
//        }
//        .padding()
//    }
//}
