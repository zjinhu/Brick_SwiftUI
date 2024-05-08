import Foundation

public extension Date {

    var day: Int? { day() }

    var hour: Int? { hour() }

    var minute: Int? { minute() }

    var month: Int? { month() }

    var second: Int? { second() }

    var year: Int? { year() }

    func day(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.day], from: self).day
    }

    func hour(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.hour], from: self).hour
    }

    func minute(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.minute], from: self).minute
    }

    func month(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.month], from: self).month
    }

    func second(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.second], from: self).second
    }

    func year(for calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([.year], from: self).year
    }
}
