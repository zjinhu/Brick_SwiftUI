//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/27.
//

import SwiftUI

/// 富文本构建器/Rich text builder
/// 用于构建富文本的ArrayBuilder别名。/ArrayBuilder alias for building rich text.
public typealias RichText = ArrayBuilder<Text>

/// Text扩展/Rich text init/Text extension for rich text init
extension Text {
    
    /// 使用分隔符初始化文本/Initialize text with separator
    @_disfavoredOverload
        @inlinable
        public init<S: StringProtocol>(
            separator: S,
            @RichText blocks: () -> [Text]
        ) {
            self.init(separator: Text(separator), blocks: blocks)
        }

    /// 使用本地化分隔符初始化文本/Initialize text with localized separator
        @inlinable
        public init(
            separator: LocalizedStringKey,
            @RichText blocks: () -> [Text]
        ) {
            self.init(separator: Text(separator), blocks: blocks)
        }

    /// 使用Text分隔符初始化文本/Initialize text with Text separator
        @inlinable
        public init(
            separator: Text,
            @RichText blocks: () -> [Text]
        ) {
            let blocks = blocks()
            switch blocks.count {
            case 0:
                self = Text(verbatim: "")

            case 1:
                self = blocks[0]

            default:
                self = blocks.dropFirst().reduce(into: blocks[0]) { result, text in
                    result = result + separator + text
                }
            }
        }
}

/// 数组构建器/Array builder
/// ResultBuilder用于构建元素数组。/ResultBuilder for building arrays of elements.
@frozen
@resultBuilder
public struct ArrayBuilder<Element> {

    /// 构建空块/Build empty block
    @inlinable
    public static func buildBlock() -> [Optional<Element>] {
        []
    }

    /// 构建首个块/Build first block
    @inlinable
    public static func buildPartialBlock(
        first: [Optional<Element>]
    ) -> [Optional<Element>] {
        first
    }

    /// 累加下一个块/Accumulate next block
    @inlinable
    public static func buildPartialBlock(
        accumulated: [Optional<Element>],
        next: [Optional<Element>]
    ) -> [Optional<Element>] {
        accumulated + next
    }

    /// 构建表达式/Build expression
    @inlinable
    public static func buildExpression(
        _ expression: Element
    ) -> [Optional<Element>] {
        [expression]
    }

    /// 构建条件分支(first)/Build conditional branch (first)
    @inlinable
    public static func buildEither(
        first component: [Optional<Element>]
    ) -> [Optional<Element>] {
        component
    }

    /// 构建条件分支(second)/Build conditional branch (second)
    @inlinable
    public static func buildEither(
        second component: [Optional<Element>]
    ) -> [Optional<Element>] {
        component
    }

    /// 构建可选值/Build optional value
    @inlinable
    public static func buildOptional(
        _ component: [Optional<Element>]?
    ) -> [Optional<Element>] {
        component ?? []
    }

    /// 构建有限可用性/Build limited availability
    @inlinable
    public static func buildLimitedAvailability(
        _ component: [Optional<Element>]
    ) -> [Optional<Element>] {
        component
    }

    /// 构建数组/Build array
    @inlinable
    public static func buildArray(
        _ components: [Optional<Element>]
    ) -> [Optional<Element>] {
        components
    }

    /// 构建块/Build block
    @inlinable
    public static func buildBlock(
        _ components: [Optional<Element>]...
    ) -> [Optional<Element>] {
        components.flatMap { $0 }
    }

    /// 构建最终结果/Build final result
    public static func buildFinalResult(
        _ component: [Optional<Element>]
    ) -> [Element] {
        component.compactMap { $0 }
    }
}

// MARK: - Previews

struct RichText_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
    
    struct Preview: View {
        @State var flag = false
        
        var body: some View {
            VStack {
                Toggle(isOn: $flag) { Text("Flag") }
                
                Text(separator: " ") {
                    if flag {
                        Text("~")
                    }
                    
                    Text("Hello")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text("World")
                        .fontWeight(.light)
                    
                    if flag {
                        Text("!")
                    } else {
                        Text(".")
                    }
                }
            }
        }
    }
}
