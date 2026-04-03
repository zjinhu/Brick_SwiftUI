import Foundation

/// Calendar 扩展/Calendar extension
public extension Calendar {
    /// 判断两个日期是否同一天/Whether two dates are same day
    /// - Parameters:
    ///   - date1: 日期1/Date 1
    ///   - date2: 日期2/Date 2
    /// - Returns: 是否同一天/Whether same day
    func isDate(_ date1: Date,
                sameDayAs date2: Date) -> Bool {
        isDate(date1, equalTo: date2, toGranularity: .day)
    }
    
    /// 判断两个日期是否同一月/Whether two dates are same month
    /// - Parameters:
    ///   - date1: 日期1/Date 1
    ///   - date2: 日期2/Date 2
    /// - Returns: 是否同一月/Whether same month
    func isDate(_ date1: Date,
                sameMonthAs date2: Date) -> Bool {
        isDate(date1, equalTo: date2, toGranularity: .month)
    }
    
    /// 判断两个日期是否同一周/Whether two dates are same week
    /// - Parameters:
    ///   - date1: 日期1/Date 1
    ///   - date2: 日期2/Date 2
    /// - Returns: 是否同一周/Whether same week
    func isDate(_ date1: Date,
                sameWeekAs date2: Date) -> Bool {
        isDate(date1, equalTo: date2, toGranularity: .weekOfYear)
    }
    
    /// 判断两个日期是否同一年/Whether two dates are same year
    /// - Parameters:
    ///   - date1: 日期1/Date 1
    ///   - date2: 日期2/Date 2
    /// - Returns: 是否同一年/Whether same year
    func isDate(_ date1: Date,
                sameYearAs date2: Date) -> Bool {
        isDate(date1, equalTo: date2, toGranularity: .year)
    }
    
    /// 判断日期是否在本月/Whether date is in this month
    /// - Parameter date: 日期/Date
    /// - Returns: 是否在本月/Whether in this month
    func isDateThisMonth(_ date: Date) -> Bool {
        isDate(date, sameMonthAs: Date())
    }
    
    /// 判断日期是否在本周/Whether date is in this week
    /// - Parameter date: 日期/Date
    /// - Returns: 是否在本周/Whether in this week
    func isDateThisWeek(_ date: Date) -> Bool {
        isDate(date, sameWeekAs: Date())
    }
    
    /// 判断日期是否在今年/Whether date is in this year
    /// - Parameter date: 日期/Date
    /// - Returns: 是否在今年/Whether in this year
    func isDateThisYear(_ date: Date) -> Bool {
        isDate(date, sameYearAs: Date())
    }
    
    /// 判断日期是否是今天/Whether date is today
    /// - Parameter date: 日期/Date
    /// - Returns: 是否是今天/Whether is today
    func isDateToday(_ date: Date) -> Bool {
        isDate(date, sameDayAs: Date())
    }
}
