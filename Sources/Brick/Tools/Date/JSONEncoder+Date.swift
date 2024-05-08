import Foundation

public extension JSONEncoder {

    static var iso8601: JSONEncoder {
        let decoder = JSONEncoder()
        decoder.dateEncodingStrategy = .customISO8601
        return decoder
    }
}

private extension JSONEncoder.DateEncodingStrategy {

    static let customISO8601 = custom { (date, encoder) throws -> Void in
        let formatter = DateFormatter.iso8601Milliseconds
        let string = formatter.string(from: date)
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
