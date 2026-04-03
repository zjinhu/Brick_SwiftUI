import Foundation

/// Date 扩展 - 添加和移除时间/Date extension - Add and remove time
public extension Date {

    /// 添加天数/Add days
    /// - Parameter days: 天数 (可小数)/Days (can be decimal)
    /// - Returns: 新日期/New date
    func adding(days: Double) -> Date {
        let seconds = Double(days) * 60 * 60 * 24
        return addingTimeInterval(seconds)
    }

    /// 添加小时/Add hours
    /// - Parameter hours: 小时 (可小数)/Hours (can be decimal)
    /// - Returns: 新日期/New date
    func adding(hours: Double) -> Date {
        let seconds = Double(hours) * 60 * 60
        return addingTimeInterval(seconds)
    }

    /// 添加分钟/Add minutes
    /// - Parameter minutes: 分钟 (可小数)/Minutes (can be decimal)
    /// - Returns: 新日期/New date
    func adding(minutes: Double) -> Date {
        let seconds = Double(minutes) * 60
        return addingTimeInterval(seconds)
    }

    /// 添加秒/Add seconds
    /// - Parameter seconds: 秒/Seconds
    /// - Returns: 新日期/New date
    func adding(seconds: Double) -> Date {
        addingTimeInterval(Double(seconds))
    }

    /// 移除天数/Remove days
    /// - Parameter days: 天数 (可小数)/Days (can be decimal)
    /// - Returns: 新日期/New date
    func removing(days: Double) -> Date {
        adding(days: -days)
    }

    /// 移除小时/Remove hours
    /// - Parameter hours: 小时 (可小数)/Hours (can be decimal)
    /// - Returns: 新日期/New date
    func removing(hours: Double) -> Date {
        adding(hours: -hours)
    }

    /// 移除分钟/Remove minutes
    /// - Parameter minutes: 分钟 (可小数)/Minutes (can be decimal)
    /// - Returns: 新日期/New date
    func removing(minutes: Double) -> Date {
        adding(minutes: -minutes)
    }

    /// 移除秒/Remove seconds
    /// - Parameter seconds: 秒/Seconds
    /// - Returns: 新日期/New date
    func removing(seconds: Double) -> Date {
        adding(seconds: -seconds)
    }
}
