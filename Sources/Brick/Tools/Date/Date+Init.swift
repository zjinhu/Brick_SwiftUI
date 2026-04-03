import Foundation

/// Date 扩展/Date extension
public extension Date {
    /// 使用指定组件初始化日期/Initialize date with specified components
    /// - Parameters:
    ///   - year: 年/Year
    ///   - month: 月/Month
    ///   - day: 日/Day
    ///   - hour: 时/Hour (default: 0)
    ///   - minute: 分/Minute (default: 0)
    ///   - second: 秒/Second (default: 0)
    ///   - calendar: 日历/Calendar (default: .current)
    init?(year: Int,
          month: Int,
          day: Int,
          hour: Int = 0,
          minute: Int = 0,
          second: Int = 0,
          calendar: Calendar = .current) {
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        guard let date = calendar.date(from: components) else {
            assertionFailure("Invalid date")
            return nil
        }
        self = date
    }
}
