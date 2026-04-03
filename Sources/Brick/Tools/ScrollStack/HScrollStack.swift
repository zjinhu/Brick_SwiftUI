import SwiftUI

/// 尊重如 `Spacer()` 元素的可滚动水平堆栈 / A scrollable `HStack` that respects elemnts like `Spacer()`
public struct HScrollStack<Content: View>: View {
    /// 垂直对齐方式 / Vertical alignment
    private let alignment: VerticalAlignment
    /// 元素间距 / Spacing between elements
    private let spacing: CGFloat?
    /// 是否显示滚动指示器 / Whether to show scroll indicators
    private let showsIndicators: Bool
    /// 内容视图 / Content view
    private let content: Content
    
    /// 初始化水平滚动堆栈 / Initialize horizontal scroll stack
    /// - Parameters:
    ///   - alignment: 垂直对齐方式 / Vertical alignment (default: .center)
    ///   - spacing: 元素间距 / Spacing between elements (default: nil)
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators (default: false)
    ///   - content: 内容视图构建器 / Content view builder
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, showsIndicators: Bool = false, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: showsIndicators) {
            LazyHStack(alignment: alignment, spacing: spacing) {
                content
            }
        }
    }
}

/// 可滚动的水平网格视图 / A scrollable horizontal grid view
public struct HScrollGrid<Content: View>: View {
    /// 垂直对齐方式 / Vertical alignment
    private let alignment: VerticalAlignment
    /// 元素间距 / Spacing between elements
    private let spacing: CGFloat?
    /// 是否显示滚动指示器 / Whether to show scroll indicators
    private let showsIndicators: Bool
    /// 内容视图 / Content view
    private let content: Content
    /// 行配置数组 / Rows configuration array
    private let rows: [GridItem]
    
    /// 使用行数初始化 / Initialize with rows count (backward compatible)
    /// - Parameters:
    ///   - rowsCount: 行数 / Number of rows
    ///   - alignment: 垂直对齐方式 / Vertical alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    public init(rowsCount: Int,
                alignment: VerticalAlignment = .center,
                spacing: CGFloat? = nil,
                showsIndicators: Bool = false,
                @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
        self.rows = Array(repeating: GridItem(.flexible(), spacing: spacing), count: rowsCount)
    }
    
    /// 使用自定义 GridItem 数组初始化 / Initialize with custom GridItem array
    /// - Parameters:
    ///   - rows: 自定义行配置 / Custom rows configuration
    ///   - alignment: 垂直对齐方式 / Vertical alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    public init(rows: [GridItem],
                alignment: VerticalAlignment = .center,
                spacing: CGFloat? = nil,
                showsIndicators: Bool = false,
                @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
        self.rows = rows
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: showsIndicators) {
            LazyHGrid(rows: rows,
                      alignment: alignment,
                      spacing: spacing) {
                content
            }
        }
    }
}

// MARK: - 便利扩展 / Convenience Extensions
public extension HScrollGrid {
    
    /// 创建固定高度行的便利初始化器 / Convenience initializer for fixed height rows
    /// - Parameters:
    ///   - heights: 固定高度数组 / Array of fixed heights
    ///   - alignment: 垂直对齐方式 / Vertical alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    /// - Returns: 水平滚动网格 / HScrollGrid instance
    static func fixedRows(heights: [CGFloat],
                         alignment: VerticalAlignment = .center,
                         spacing: CGFloat? = nil,
                         showsIndicators: Bool = false,
                         @ViewBuilder content: () -> Content) -> HScrollGrid {
        let rows = heights.map { GridItem(.fixed($0), spacing: spacing) }
        return HScrollGrid(rows: rows,
                          alignment: alignment,
                          spacing: spacing,
                          showsIndicators: showsIndicators,
                          content: content)
    }
    
    /// 创建自适应行的便利初始化器 / Convenience initializer for adaptive rows
    /// - Parameters:
    ///   - minimum: 最小高度 / Minimum height
    ///   - maximum: 最大高度 / Maximum height
    ///   - alignment: 垂直对齐方式 / Vertical alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    /// - Returns: 水平滚动网格 / HScrollGrid instance
    static func adaptiveRows(minimum: CGFloat,
                            maximum: CGFloat = .infinity,
                            alignment: VerticalAlignment = .center,
                            spacing: CGFloat? = nil,
                            showsIndicators: Bool = false,
                            @ViewBuilder content: () -> Content) -> HScrollGrid {
        let rows = [GridItem(.adaptive(minimum: minimum, maximum: maximum), spacing: spacing)]
        return HScrollGrid(rows: rows,
                          alignment: alignment,
                          spacing: spacing,
                          showsIndicators: showsIndicators,
                          content: content)
    }
    
    /// 创建混合类型行的便利初始化器 / Convenience initializer for mixed type rows
    /// - Parameters:
    ///   - flexibleCount: 灵活行数量 / Number of flexible rows
    ///   - fixedHeights: 固定高度数组 / Array of fixed heights
    ///   - alignment: 垂直对齐方式 / Vertical alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    /// - Returns: 水平滚动网格 / HScrollGrid instance
    static func mixedRows(flexibleCount: Int,
                         fixedHeights: [CGFloat] = [],
                         alignment: VerticalAlignment = .center,
                         spacing: CGFloat? = nil,
                         showsIndicators: Bool = false,
                         @ViewBuilder content: () -> Content) -> HScrollGrid {
        var rows: [GridItem] = []
        
        // 添加灵活行 / Add flexible rows
        rows.append(contentsOf: Array(repeating: GridItem(.flexible(), spacing: spacing), count: flexibleCount))
        
        // 添加固定高度行 / Add fixed height rows
        rows.append(contentsOf: fixedHeights.map { GridItem(.fixed($0), spacing: spacing) })
        
        return HScrollGrid(rows: rows,
                          alignment: alignment,
                          spacing: spacing,
                          showsIndicators: showsIndicators,
                          content: content)
    }
    
    /// 创建单行水平滚动网格的便利初始化器 / Convenience initializer for single row horizontal scroll grid
    /// - Parameters:
    ///   - height: 固定高度（可选）/ Fixed height (optional)
    ///   - alignment: 垂直对齐方式 / Vertical alignment
    ///   - spacing: 元素间距 / Spacing between elements
    ///   - showsIndicators: 是否显示滚动指示器 / Show scroll indicators
    ///   - content: 内容视图构建器 / Content view builder
    /// - Returns: 水平滚动网格 / HScrollGrid instance
    static func singleRow(height: CGFloat? = nil,
                         alignment: VerticalAlignment = .center,
                         spacing: CGFloat? = nil,
                         showsIndicators: Bool = false,
                         @ViewBuilder content: () -> Content) -> HScrollGrid {
        let gridItem: GridItem
        if let height = height {
            gridItem = GridItem(.fixed(height), spacing: spacing)
        } else {
            gridItem = GridItem(.flexible(), spacing: spacing)
        }
        
        return HScrollGrid(rows: [gridItem],
                          alignment: alignment,
                          spacing: spacing,
                          showsIndicators: showsIndicators,
                          content: content)
    }
}

// MARK: - 使用示例
//struct HScrollGridExamples: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            
//            // 1. 使用原有的行数初始化（向后兼容）
//            HScrollGrid(rowsCount: 3, spacing: 10) {
//                ForEach(0..<15, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.blue.opacity(0.6))
//                        .frame(width: 80)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 200)
//            
//            // 2. 使用自定义 GridItem 数组
//            HScrollGrid(rows: [
//                GridItem(.fixed(60), spacing: 5),
//                GridItem(.flexible(), spacing: 5),
//                GridItem(.fixed(40), spacing: 5)
//            ], spacing: 10) {
//                ForEach(0..<12, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.green.opacity(0.6))
//                        .frame(width: 70)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 150)
//            
//            // 3. 使用固定高度行的便利方法
//            HScrollGrid.fixedRows(heights: [50, 80, 50], spacing: 8) {
//                ForEach(0..<12, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.orange.opacity(0.6))
//                        .frame(width: 60)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 200)
//            
//            // 4. 使用自适应行
//            HScrollGrid.adaptiveRows(minimum: 60, spacing: 10) {
//                ForEach(0..<20, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.purple.opacity(0.6))
//                        .frame(width: 80)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 120)
//            
//            // 5. 使用混合类型行
//            HScrollGrid.mixedRows(flexibleCount: 2, fixedHeights: [40], spacing: 8) {
//                ForEach(0..<15, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.red.opacity(0.6))
//                        .frame(width: 65)
//                        .overlay(Text("\(index)"))
//                }
//            }
//            .frame(height: 140)
//            
//            // 6. 单行水平滚动（最常用的场景）
//            HScrollGrid.singleRow(height: 80, spacing: 12) {
//                ForEach(0..<10, id: \.self) { index in
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color.mint.opacity(0.7))
//                        .frame(width: 100)
//                        .overlay(
//                            VStack {
//                                Image(systemName: "star.fill")
//                                    .foregroundColor(.white)
//                                Text("Item \(index)")
//                                    .font(.caption)
//                                    .foregroundColor(.white)
//                            }
//                        )
//                }
//            }
//            .frame(height: 80)
//        }
//        .padding()
//    }
//}
