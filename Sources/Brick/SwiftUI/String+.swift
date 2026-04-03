//
//  String+.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2025.06.05.
//
import SwiftUI

extension StringProtocol {
    /// 检查字符串是否包含指定的值。/ Returns `true` iff `value` is in `self`.
    /// - Parameters:
    ///   - value: 要搜索的字符串。/ The string to search for.
    ///   - options: 比较选项，默认为空。/ The comparison options.
    /// - Returns: 如果包含则返回true。/ Returns `true` if the string contains the value.
    public func contains(_ value: some StringProtocol, options: String.CompareOptions = []) -> Bool {
        range(of: value, options: options) != nil
    }

    /// 返回字符串首字符的大写形式。/ A uppercase representation of the first character in string.
    /// - Returns: 首字符大写的字符串。/ String with first character uppercased.
    public func uppercasedFirst() -> String {
        prefix(1).uppercased() + dropFirst()
    }

    /// 返回字符串首字符的小写形式。/ A lowercase representation of the first character in string.
    /// - Returns: 首字符小写的字符串。/ String with first character lowercased.
    public func lowercasedFirst() -> String {
        prefix(1).lowercased() + dropFirst()
    }

    /// 返回字符串的驼峰命名形式。/ A camel case representation of the string.
    /// - Returns: 驼峰格式的字符串（例如 "helloWorld"）。/ String in camel case format.
    public func camelcased() -> String {
        parts().lazy.enumerated().map {
            if $0.offset == 0 {
                return $0.element.lowercasedFirst()
            }

            return $0.element.uppercasedFirst()
        }.joined()
    }

    /// 返回字符串的蛇形命名形式。/ A snake case representation of the string.
    /// - Returns: 蛇形格式的字符串（例如 "hello_world"）。/ String in snake case format.
    public func snakecased() -> String {
        parts().joined(separator: "_")
    }

    private func parts() -> [String] {
        guard !isEmpty else {
            return []
        }

        let normalized: String

        // If all uppercase then lowercase everything.
        if rangeOfCharacter(from: .lowercaseLetters, options: [], range: range) == nil {
            normalized = lowercased()
        } else {
            normalized = replacingOccurrences(of: "(?=\\S)[A-Z]", with: " $0", options: .regularExpression, range: range).lowercased()
        }

        return normalized.components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty }
    }

    fileprivate var range: Range<String.Index> {
        Range(uncheckedBounds: (startIndex, endIndex))
    }
}

extension String {
    // Credit: https://gist.github.com/devxoul/a1e6822def36f75d0bc5
    //
    /// 返回字符串的标题形式。/ A title case representation of the string.
    /// - Returns: 标题格式的字符串（例如 "Hello World"）。/ String in title case format.
    public func titlecased() -> String {
        if count <= 1 {
            return uppercased()
        }

        // If all uppercase then lowercase everything and title case the first character.
        if rangeOfCharacter(from: .lowercaseLetters, options: [], range: range) == nil {
            return lowercased().uppercasedFirst()
        }

        let regex = try! NSRegularExpression(pattern: "(?=\\S)[A-Z]")
        let range = NSRange(location: 1, length: 1)

        var titlecased = regex.stringByReplacingMatches(in: self, range: range, withTemplate: " $0")

        for i in titlecased.indices {
            if i == titlecased.startIndex || titlecased[titlecased.index(before: i)] == " " {
                titlecased.replaceSubrange(i...i, with: titlecased[i].uppercased())
            }
        }

        return titlecased
    }
}

extension String {
    /// 使用百分比编码替换字符串中不在指定字符集中的所有字符。/ Returns a new string created by replacing all characters in the string not in the specified set with percent encoded characters.
    ///
    /// 默认值为`.urlQueryAllowed`。/ The default value is `.urlQueryAllowed`.
    ///
    /// - Parameter allowedCharacters: 允许的字符集。/ The allowed character set.
    /// - Returns: 编码后的字符串，可能为nil。/ Returns an escaped string, or nil if encoding fails.
    public func urlEscaped(allowed allowedCharacters: CharacterSet = .urlQueryAllowed) -> String? {
        addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }

    /// 返回按换行符分割的字符串数组。/ Returns an array of strings at new lines.
    /// - Returns: 按换行符分割的字符串数组。/ An array of strings split by newlines.
    public func lines() -> [String] {
        components(separatedBy: .newlines)
    }

    /// 规范化多个空白字符并去除首尾空白和换行符。/ Normalize multiple whitespaces and trim whitespaces and new line characters in `self`.
    /// - Returns: 规范化后的字符串。/ The trimmed and normalized string.
    public func trimmed() -> String {
        replacing("[ ]+", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 在字符串中搜索匹配项并用指定字符串替换。/ Searches for pattern matches in the string and replaces them with replacement.
    /// - Parameters:
    ///   - pattern: 要匹配的正则表达式模式。/ The pattern to match.
    ///   - with: 替换用的字符串。/ The replacement string.
    ///   - options: 比较选项，默认为正则表达式。/ The comparison options.
    /// - Returns: 替换后的字符串。/ The string with replacements made.
    public func replacing(
        _ pattern: String,
        with: String,
        options: String.CompareOptions = .regularExpression
    ) -> String {
        replacingOccurrences(of: pattern, with: with, options: options, range: nil)
    }

    /// 去除首尾空白并用指定字符串替换多个连续空白。/ Trim whitespaces from start and end and normalize multiple whitespaces into one and then replace them with the given string.
    /// - Parameter string: 用于替换的字符串。/ The string to replace whitespaces with.
    /// - Returns: 处理后的字符串。/ The processed string.
    public func replacingWhitespaces(with string: String) -> String {
        trimmingCharacters(in: .whitespaces).replacing("[ ]+", with: string)
    }

    /// 判断字符串是否为有效的URL。/ Determine whether the string is a valid url.
    /// - Returns: 如果是有效URL则返回true。/ `true` iff the string is a valid URL.
    public var isValidUrl: Bool {
        if let url = URL(string: self), url.host != nil {
            return true
        }

        return false
    }

    /// 判断字符串是否为空或仅包含空白字符（包括换行符和空格）。/ `true` iff `self` contains no characters and blank spaces (e.g., \n, " ").
    /// - Returns: 如果为空或空白则返回true。/ `true` if the string is empty or blank.
    public var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 移除字符串的前缀。/ Drops the given `prefix` from `self`.
    ///
    /// - Parameter prefix: 要移除的前缀。/ The prefix to remove.
    /// - Returns: 移除前缀后的字符串，如果前缀不存在则返回原字符串。/ String without the specified `prefix` or unmodified `self` if `prefix` doesn't exist.
    public func droppingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }

        return String(dropFirst(prefix.count))
    }

    /// 移除字符串的后缀。/ Drops the given `suffix` from `self`.
    ///
    /// - Parameter suffix: 要移除的后缀。/ The suffix to remove.
    /// - Returns: 移除后缀后的字符串，如果后缀不存在则返回原字符串。/ String without the specified `suffix` or unmodified `self` if `suffix` doesn't exist.
    public func droppingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else {
            return self
        }

        return String(dropLast(suffix.count))
    }

    /// 获取字符串的最后n个字符。/ Take last `x` characters from `self`.
    ///
    /// - Parameter last: 要获取的字符数量。/ The number of characters to take from the end.
    /// - Returns: 最后n个字符的字符串。/ String containing the last `last` characters.
    public func take(last: Int) -> String {
        guard count >= last else {
            return self
        }

        return String(dropFirst(count - last))
    }
}

// MARK: - Random

extension String {
    /// 从原字符串中随机选取指定长度的字符生成新字符串。/ Generates a new string containing random characters from the string, with the specified length.
    ///
    /// 如果长度大于字符串的字符数，将重复选取字符以达到要求的长度。/ If the length is greater than the string's character count, the method will repeat character selection to fulfill the requested length.
    ///
    /// - Parameter length: 生成的字符串长度。/ The desired number of characters in the resulting string.
    /// - Returns: 由随机字符组成的字符串。/ A string composed of random characters from the original string.
    public func random(length: Int) -> String {
        String((0..<length).compactMap { _ in randomElement() })
    }

    /// 生成指定长度的随机字母数字字符串。/ Generates a random alphanumeric string of the specified length.
    ///
    /// 包含大小写字母和数字。/ This method creates a string containing a random sequence of letters (uppercase and lowercase) and numbers.
    ///
    /// - Parameter length: 生成的字符串长度，默认为10。/ The desired length of the generated string.
    /// - Returns: 由随机字母数字组成的字符串。/ A string consisting of random alphanumeric characters.
    public static func random(length: Int = 10) -> String {
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            .random(length: length)
    }
}

// MARK: - Truncation

extension String {
    /// 字符串截断位置的枚举。/ Truncation position options for string truncation.
    public enum TruncationPosition: Sendable, Hashable {
        /// 头部截断：显示末尾字符/"...wxyz" / Truncate at head: `"...wxyz"`
        case head
        /// 中间截断：显示首尾字符/"ab...yz" / Truncate middle: `"ab...yz"`
        case middle
        /// 尾部截断：显示开头字符/"abcd..." / Truncate at tail: `"abcd..."`
        case tail
    }

    /// 将字符串截断到指定长度并在指定位置添加省略号。/ Truncates the string to the specified length and appends an ellipsis string at the given truncation position.
    ///
    /// 示例：/ Example:
    /// ```swift
    /// let result = "This is a really long string".truncate(10)
    /// print(result)
    /// // "This is a ..."
    /// ```
    ///
    /// - Parameters:
    ///   - length: 最大长度。/ The maximum length of the string.
    ///   - position: 截断位置，默认为尾部。/ The truncation position option.
    ///   - ellipsis: 省略号字符串，默认为"..."。/ A `String` that will be appended in the truncation position.
    /// - Returns: 截断后的字符串。/ The truncated string.
    public func truncate(
        _ length: Int,
        position: TruncationPosition = .tail,
        ellipsis: String = "..."
    ) -> String {
        guard count > length else { return self }

        switch position {
            case .head:
                return ellipsis + suffix(length)
            case .middle:
                let count = Double(length - ellipsis.count) / 2
                let headCount = Int(ceil(count))
                let tailCount = Int(floor(count))
                return "\(prefix(headCount))\(ellipsis)\(suffix(tailCount))"
            case .tail:
                return prefix(length) + ellipsis
        }
    }
}

extension String {
    /// 如果字符串为空则返回nil。/ Returns `nil` if the string is empty.
    /// - Returns: 空字符串返回nil，否则返回自身。/ `nil` if empty, otherwise returns self.
    public var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    /// 如果字符串为空白则返回nil。/ Returns `nil` if the string is blank.
    /// - Returns: 空白字符串返回nil，否则返回自身。/ `nil` if blank, otherwise returns self.
    public var nilIfBlank: String? {
        isBlank ? nil : self
    }
}