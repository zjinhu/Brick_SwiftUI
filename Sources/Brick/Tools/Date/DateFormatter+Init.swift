import Foundation

/// DateFormatter 扩展/DateFormatter extension
public extension DateFormatter {
    /// 使用日期和时间样式初始化/Initialize with date and time style
    /// - Parameters:
    ///   - dateStyle: 日期样式/Date style
    ///   - timeStyle: 时间样式/Time style (default: .none)
    ///   - locale: 区域设置/Locale (default: en_US_POSIX)
    ///   - calendar: 日历/Calendar (default: iso8601)
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
    
    /// 使用日期格式字符串初始化/Initialize with date format string
    /// - Parameters:
    ///   - dateFormat: 日期格式字符串/Date format string
    ///   - calendar: 日历/Calendar (default: iso8601)
    ///   - locale: 区域设置/Locale (default: en_US_POSIX)
    ///   - timeZone: 时区/TimeZone (default: GMT)
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
    
    /// ISO8601 秒级格式/ISO8601 seconds format
    static var iso8601Seconds: DateFormatter {
        .init(dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
    
    /// ISO8601 毫秒级格式/ISO8601 milliseconds format
    static var iso8601Milliseconds: DateFormatter {
        .init(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    }
}
