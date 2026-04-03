import Foundation

/// Date 扩展 - 日期差异/Date extension - Date difference
public extension Date {

    /// 从指定日期到当前的年数/Years from date to current
    /// - Parameters:
    ///   - date: 起始日期/Start date
    ///   - calendar: 日历/Calendar (default: .current)
    /// - Returns: 年数/Years
    func years(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.year], from: date, to: self).year ?? 0
    }

    /// 从指定日期到当前的月数/Months from date to current
    /// - Parameters:
    ///   - date: 起始日期/Start date
    ///   - calendar: 日历/Calendar (default: .current)
    /// - Returns: 月数/Months
    func months(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.month], from: date, to: self).month ?? 0
    }

    /// 从指定日期到当前的周数/Weeks from date to current
    /// - Parameters:
    ///   - date: 起始日期/Start date
    ///   - calendar: 日历/Calendar (default: .current)
    /// - Returns: 周数/Weeks
    func weeks(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }

    /// 从指定日期到当前的天数/Days from date to current
    /// - Parameters:
    ///   - date: 起始日期/Start date
    ///   - calendar: 日历/Calendar (default: .current)
    /// - Returns: 天数/Days
    func days(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// 从指定日期到当前的小时数/Hours from date to current
    /// - Parameters:
    ///   - date: 起始日期/Start date
    ///   - calendar: 日历/Calendar (default: .current)
    /// - Returns: 小时数/Hours
    func hours(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// 从指定日期到当前分钟/Minutes from date to current
    /// - Parameters:
    ///   - date: 起始日期/Start date
    ///   - calendar: 日历/Calendar (default: .current)
    /// - Returns: 分钟数/Minutes
    func minutes(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// 从指定日期到当前的秒数/Seconds from date to current
    /// - Parameters:
    ///   - date: 起始日期/Start date
    ///   - calendar: 日历/Calendar (default: .current)
    /// - Returns: 秒数/Seconds
    func seconds(from date: Date, calendar: Calendar = .current) -> Int {
        calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
