import Foundation

public extension Calendar {
    
    func isDate(_ date1: Date,
                sameDayAs date2: Date) -> Bool {
        isDate(date1, equalTo: date2, toGranularity: .day)
    }
    
    func isDate(_ date1: Date,
                sameMonthAs date2: Date) -> Bool {
        isDate(date1, equalTo: date2, toGranularity: .month)
    }
    
    func isDate(_ date1: Date,
                sameWeekAs date2: Date) -> Bool {
        isDate(date1, equalTo: date2, toGranularity: .weekOfYear)
    }
    
    func isDate(_ date1: Date,
                sameYearAs date2: Date) -> Bool {
        isDate(date1, equalTo: date2, toGranularity: .year)
    }
    
    func isDateThisMonth(_ date: Date) -> Bool {
        isDate(date, sameMonthAs: Date())
    }
    
    func isDateThisWeek(_ date: Date) -> Bool {
        isDate(date, sameWeekAs: Date())
    }
    
    func isDateThisYear(_ date: Date) -> Bool {
        isDate(date, sameYearAs: Date())
    }
    
    func isDateToday(_ date: Date) -> Bool {
        isDate(date, sameDayAs: Date())
    }
}
