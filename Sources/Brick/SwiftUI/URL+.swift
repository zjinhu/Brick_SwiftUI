//
//  URL+.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2025.06.05.
//  URL 扩展 - 提供 URL 查询参数操作功能 / URL extension - provides URL query parameter manipulation
//

import Foundation

// MARK: - URL Init with Query Parameters / URL 初始化扩展

/// URL 扩展 / URL extension
extension URL {
    /// 从字符串和查询参数创建 URL / Create URL from string and query parameters
    /// - Parameters:
    ///   - string: URL 字符串 / URL string
    ///   - queryParameters: 查询参数字典 / Query parameters dictionary
    public init?(string: String, queryParameters: [String: String]) {
        var components = URLComponents(string: string)
        components?.queryItems = queryParameters.map(URLQueryItem.init)

        guard let string = components?.url?.absoluteString else {
            return nil
        }

        self.init(string: string)
    }

    /// 获取指定名称的查询值 / Get query value associated with the request
    /// - Parameter name: 查询参数名称 / Query parameter name
    /// - Returns: 查询值 / Query value
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.queryItem(named: "q")) // "HelloWorld"
    /// ```
    public func queryItem(named name: String) -> String? {
        guard let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: true)?.queryItems else {
            return nil
        }

        return queryItems.first { $0.name == name }?.value
    }
}

// MARK: - Appending Query Items / 添加查询参数

/// URL 查询参数添加扩展 / URL append query items extension
extension URL {
    /// 添加查询参数 / Appends the given query item to the URL
    /// - Parameters:
    ///   - name: 参数名称 / Parameter name
    ///   - value: 参数值 / Parameter value
    /// - Returns: 新 URL / New URL
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.appendQueryItem(named: "lang", value: "Swift")) // "https://example.com/?q=HelloWorld&lang=Swift"
    /// ```
    public func appendQueryItem(named name: String, value: String?) -> URL {
        appendQueryItem(.init(name: name, value: value))
    }

    /// 添加 URLQueryItem / Appends the given query item to the URL
    /// - Parameter item: URLQueryItem
    /// - Returns: 新 URL / New URL
    public func appendQueryItem(_ item: URLQueryItem) -> URL {
        appendQueryItems([item])
    }

    /// 批量添加查询参数 / Appends the given list of query items to the URL
    /// - Parameter items: URLQueryItem 数组 / Array of URLQueryItem
    /// - Returns: 新 URL / New URL
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.appendQueryItems([URLQueryItem(name: "lang", value: "Swift")]) // "https://example.com/?q=HelloWorld&lang=Swift"
    /// ```
    public func appendQueryItems(_ items: [URLQueryItem]) -> URL {
        guard
            !items.isEmpty,
            var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        else {
            return self
        }

        var queryItems = components.queryItems ?? []
        queryItems.append(contentsOf: items)
        components.queryItems = Array(queryItems.reversed()).uniqued(\.name).reversed()

        return components.url ?? self
    }
}

// MARK: - Removing Query Items / 删除查询参数

/// URL 查询参数删除扩展 / URL remove query items extension
extension URL {
    /// 删除所有查询参数 / Removes all the query items
    /// - Returns: 新 URL / New URL
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld")!
    /// print(url.removingQueryItems()) // "https://example.com"
    /// ```
    public func removingQueryItems() -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        components.query = nil

        return components.url ?? self
    }

    /// 删除指定名称的查询参数 / Removes all the query items that are in the given list
    /// - Parameter names: 要删除的参数名称数组 / Array of parameter names to remove
    /// - Returns: 新 URL / New URL
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.removingQueryItems(["q", "lang"]) // "https://example.com/"
    /// ```
    public func removingQueryItems(_ names: [String]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            return self
        }

        components.queryItems?.removeAll { item in
            names.contains(item.name)
        }

        if components.queryItems?.isEmpty == true {
            components.queryItems = nil
        }

        return components.url ?? self
    }

    /// 删除指定名称的查询参数 / Removes all the query items that match the given name
    /// - Parameter name: 要删除的参数名称 / Parameter name to remove
    /// - Returns: 新 URL / New URL
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.removingQueryItem(named: "q")) // "https://example.com/?lang=swift"
    /// ```
    public func removingQueryItem(named name: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        if var queryItems = components.queryItems {
            queryItems.removeAll { item in
                item.name == name
            }

            if queryItems.isEmpty {
                components.queryItems = nil
            } else {
                components.queryItems = queryItems
            }
        }

        return components.url ?? self
    }

    /// 替换指定名称的查询参数值 / Replaces value of all query items that match the given name
    /// - Parameters:
    ///   - name: 要替换的参数名称 / Parameter name to replace
    ///   - value: 新值 / New value
    /// - Returns: 新 URL / New URL
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.replacingQueryItem(named: "q", with: "World")) // "https://example.com/?q=World&lang=swift"
    /// ```
    public func replacingQueryItem(named name: String, with value: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        if var queryItems = components.queryItems, !queryItems.isEmpty {
            for (index, item) in queryItems.enumerated() where item.name == name {
                queryItems[index].value = value
            }

            components.queryItems = queryItems
        }

        return components.url ?? self
    }

    /// 批量替换查询参数值 / Replaces value of given list of query items with the new provided value
    /// - Parameters:
    ///   - names: 要替换的参数名称数组 / Array of parameter names to replace
    ///   - value: 新值 / New value
    /// - Returns: 新 URL / New URL
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.replacingQueryItems(["q", "swift"], with: "xxxx")) // "https://example.com/?q=xxxx&lang=xxxx"
    /// ```
    public func replacingQueryItems(_ names: [String], with value: String) -> URL {
        guard
            !names.isEmpty,
            var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        else {
            return self
        }

        if var queryItems = components.queryItems, !queryItems.isEmpty {
            for (index, item) in queryItems.enumerated() {
                for name in names where item.name == name {
                    queryItems[index].value = value
                }
            }

            components.queryItems = queryItems
        }

        return components.url ?? self
    }

    /// 掩码所有查询参数 / Masks all query parameters from the URL
    /// - Parameter mask: 掩码字符 / Mask character
    /// - Returns: 新 URL / New URL
    /// ```
    /// let url = URL(string: "https://example.com/?q=HelloWorld&lang=swift")!
    /// print(url.maskingAllQueryItems()) // "https://example.com/?q=xxxx&lang=xxxx"
    /// ```
    public func maskingAllQueryItems(mask: String = "xxxx") -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        if var queryItems = components.queryItems, !queryItems.isEmpty {
            for index in queryItems.indices {
                queryItems[index].value = mask
            }

            components.queryItems = queryItems
        }

        return components.url ?? self
    }
}

// MARK: - Removing Components / 移除组件

/// URL 组件移除扩展 / URL remove components extension
extension URL {
    /// 移除锚点 / Returns a URL constructed by removing the fragment from self
    /// - Returns: 新 URL / New URL
    public func removingFragment() -> URL {
        guard let fragment else {
            return self
        }

        let urlString = absoluteString.replacing("#\(fragment)", with: "")
        return URL(string: urlString) ?? self
    }

    /// 移除协议头 / Returns string representation of the URL without scheme if present
    /// - Returns: 字符串 / String
    public func removingScheme() -> String {
        guard
            scheme != nil,
            let resource = (self as NSURL).resourceSpecifier
        else {
            return absoluteString
        }

        return String(resource.dropFirst(2))
    }
}

// MARK: - Matches / 匹配

/// URL 匹配扩展 / URL matches extension
extension URL {
    /// 检查 URL 主机是否匹配指定域名 / A Boolean property indicating whether the url's host matches given domain
    /// - Parameters:
    ///   - domain: 域名 / Domain name
    ///   - includingSubdomains: 是否包含子域名 / Whether to include subdomains
    /// - Returns: 是否匹配 / Whether matches
    /// ```
    /// let url = URL(string: "https://www.example.com")!
    /// print(url.matches("example.com")) // true
    /// print(url.matches("example.org")) // false
    ///
    /// let url = URL(string: "https://api.example.com")!
    /// print(url.matches("example.com")) // true
    /// print(url.matches("example.com", includingSubdomains: false)) // false
    /// ```
    public func matches(_ domain: String, includingSubdomains: Bool = true) -> Bool {
        if matches(host: domain) {
            return true
        } else if includingSubdomains {
            return matches(host: "*.\(domain)")
        } else {
            return false
        }
    }

    private func matches(host: String) -> Bool {
        NSPredicate(format: "SELF LIKE %@", host)
            .evaluate(with: self.host)
    }
}

// MARK: - Scheme / 协议

/// URL Scheme 扩展 / URL scheme extension
extension URL {
    /// URL 协议类型 / The scheme of the URL
    public var schemeType: Scheme {
        guard let scheme else {
            return .none
        }

        return Scheme(rawValue: scheme)
    }
}

/// URL Scheme 类型 / URL scheme type
extension URL {
    public struct Scheme: RawRepresentable, Sendable, Hashable, CustomStringConvertible {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public var description: String {
            rawValue
        }
    }
}

/// URL.Scheme 可字符串字面量初始化 / URL.Scheme expressible by string literal
extension URL.Scheme: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

/// URL.Scheme 常用值 / URL.Scheme common values
extension URL.Scheme {
    public static let none: Self = ""
    public static let https: Self = "https"
    public static let http: Self = "http"
    public static let file: Self = "file"
    public static let tel: Self = "tel"
    public static let sms: Self = "sms"
    public static let email: Self = "mailto"
}
