import Foundation

/// Date 扩展 - 日期比较/Date extension - Date comparison
public extension Date {

    /// 是否在指定日期之后/Whether after specified date
    /// - Parameter date: 比较日期/Date to compare
    /// - Returns: 是否在之后/Whether after
    func isAfter(_ date: Date) -> Bool {
        self > date
    }

    /// 是否在指定日期之前/Whether before specified date
    /// - Parameter date: 比较日期/Date to compare
    /// - Returns: 是否在之前/Whether before
    func isBefore(_ date: Date) -> Bool {
        self < date
    }

    /// 是否与指定日期相同/Whether same as specified date
    /// - Parameter date: 比较日期/Date to compare
    /// - Returns: 是否相同/Whether same
    func isSame(as date: Date) -> Bool {
        self == date
    }
}
