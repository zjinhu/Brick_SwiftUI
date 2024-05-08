import Foundation

public extension Date {

    func isAfter(_ date: Date) -> Bool {
        self > date
    }

    func isBefore(_ date: Date) -> Bool {
        self < date
    }

    func isSame(as date: Date) -> Bool {
        self == date
    }
}
