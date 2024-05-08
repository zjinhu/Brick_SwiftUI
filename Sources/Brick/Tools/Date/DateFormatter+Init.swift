import Foundation

public extension DateFormatter {
    
    convenience init(dateStyle: DateFormatter.Style,
                     timeStyle: DateFormatter.Style = .none,
                     locale: Locale = .init(identifier: "en_US_POSIX"),
                     calendar: Calendar = .init(identifier: .iso8601)) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
        self.locale = locale
        self.calendar = calendar
    }
    
    convenience init(dateFormat: String,
                     calendar: Calendar = .init(identifier: .iso8601),
                     locale: Locale = .init(identifier: "en_US_POSIX"),
                     timeZone: TimeZone? = .init(secondsFromGMT: 0)) {
        self.init()
        self.calendar = calendar
        self.locale = locale
        self.dateFormat = dateFormat
        self.timeZone = timeZone
    }
    
    static var iso8601Seconds: DateFormatter {
        .init(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
    
    static var iso8601Milliseconds: DateFormatter {
        .init(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    }
}
