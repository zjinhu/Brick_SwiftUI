import Foundation

public extension Date {
    
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
