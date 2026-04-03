import Foundation

/// JSONEncoder 扩展/JSONEncoder extension
public extension JSONEncoder {
    /// ISO8601 日期编码器/ISO8601 date encoder
    static var iso8601: JSONEncoder {
        let decoder = JSONEncoder()
        decoder.dateEncodingStrategy = .customISO8601
        return decoder
    }
}

/// JSONEncoder.DateEncodingStrategy 扩展/JSONEncoder.DateEncodingStrategy extension
private extension JSONEncoder.DateEncodingStrategy {
    /// 自定义 ISO8601 编码策略/Custom ISO8601 encoding strategy
    static let customISO8601 = custom { (date, encoder) throws -> Void in
        let formatter = DateFormatter.iso8601Milliseconds
        let string = formatter.string(from: date)
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
