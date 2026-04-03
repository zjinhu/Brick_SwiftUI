import Foundation

/// JSONDecoder 扩展/JSONDecoder extension
public extension JSONDecoder {
    /// ISO8601 日期解码器/ISO8601 date decoder
    static var iso8601: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .robustISO8601
        return decoder
    }
}

/// JSONDecoder.DateDecodingStrategy 扩展/JSONDecoder.DateDecodingStrategy extension
private extension JSONDecoder.DateDecodingStrategy {
    /// 健壮的 ISO8601 解码策略，支持秒和毫秒/Robust ISO8601 decoding strategy supporting seconds and milliseconds
    static let robustISO8601 = custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        let msFormatter = DateFormatter.iso8601Milliseconds
        let secFormatter = DateFormatter.iso8601Seconds
        if let date = msFormatter.date(from: string) ?? secFormatter.date(from: string) { return date }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
