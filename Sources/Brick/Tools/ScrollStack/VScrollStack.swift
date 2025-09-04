import SwiftUI

/// A scrollable `VStack` that respects elemnts like `Spacer()`
public struct VScrollStack<Content: View>: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let showsIndicators: Bool
    private let content: Content
    
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

public struct VScrollGrid<Content: View>: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let showsIndicators: Bool
    private let content: Content
    private let columns: [GridItem]
    
    // 使用行数初始化（保持向后兼容）
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
    
    // 使用自定义 GridItem 数组初始化
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

// MARK: - 便利扩展
public extension VScrollGrid {
    
    // 创建固定宽度列的便利初始化器
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
    
    // 创建自适应列的便利初始化器
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
    
    // 创建混合类型列的便利初始化器
    static func mixedColumns(flexibleCount: Int,
                            fixedWidths: [CGFloat] = [],
                            alignment: HorizontalAlignment = .center,
                            spacing: CGFloat? = nil,
                            showsIndicators: Bool = false,
                            @ViewBuilder content: () -> Content) -> VScrollGrid {
        var columns: [GridItem] = []
        
        // 添加灵活列
        columns.append(contentsOf: Array(repeating: GridItem(.flexible(), spacing: spacing), count: flexibleCount))
        
        // 添加固定宽度列
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
