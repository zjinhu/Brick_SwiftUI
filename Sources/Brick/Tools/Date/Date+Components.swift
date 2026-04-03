import Foundation

/// Date 扩展 - 日期组件/Date extension - Date components
public extension Date {

    /// 日/Day
    var day: Int? { day() }

    /// 时/Hour
    var hour: Int? { hour() }

    /// 分/Minute
    var minute: Int? { minute() }

    /// 月/Month
    var month: Int? { month() }

    /// 秒/Second
    var second: Int? { second() }

    /// 年/Year
    var year: Int? { year() }

    /// 获取日/Get day
    /// - Parameter calendar: 日历/Calendar (default: .current)
    /// - Returns: 日/Day
    func day(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.day], from: self).day
    }

    /// 获取时/Get hour
    /// - Parameter calendar: 日历/Calendar (default: .current)
    /// - Returns: 时/Hour
    func hour(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.hour], from: self).hour
    }

    /// 获取分/Get minute
    /// - Parameter calendar: 日历/Calendar (default: .current)
    /// - Returns: 分/Minute
    func minute(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.minute], from: self).minute
    }

    /// 获取月/Get month
    /// - Parameter calendar: 日历/Calendar (default: .current)
    /// - Returns: 月/Month
    func month(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.month], from: self).month
    }

    /// 获取秒/Get second
    /// - Parameter calendar: 日历/Calendar (default: .current)
    /// - Returns: 秒/Second
    func second(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.second], from: self).second
    }

    /// 获取年/Get year
    /// - Parameter calendar: 日历/Calendar (default: .current)
    /// - Returns: 年/Year
    func year(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.year], from: self).year
    }
}
