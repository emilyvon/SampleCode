
import Foundation

extension Date {
    
    func isSameDay(d: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: d)
    }
    
    func toLocalDateStringWithLongYear() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "dd/MM/yyyy" // e.g 08/10/2017
        return formatter.string(from: self)
    }
 
    func toLocalDateStringWithShortYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy" // e.g 08/10/17
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    
    func toLocalTime24HString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // e.g 16:08
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    
    func toLocalTime12HString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // e.g 4:08 am
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    
    static func compareDatesWithoutTimeComponents(date1: Date, date2: Date) -> ComparisonResult {
        return Calendar.current.compare(date1, to: date2, toGranularity: .day)
    }
    
    static func convertDate(date: Date, time: Date) -> Date? {
        
        let cal = Calendar.current
        
        var unitFlags = Set<Calendar.Component>([.year, .month, .day])
        let dateCmp = cal.dateComponents(unitFlags, from: date)
        
        unitFlags = Set<Calendar.Component>([.hour, .minute])
        let timeCmp = cal.dateComponents(unitFlags, from: time)
        
        var components = DateComponents()
        components.timeZone = .current
        components.year = dateCmp.year
        components.month = dateCmp.month
        components.day = dateCmp.day
        components.hour = timeCmp.hour
        components.minute = timeCmp.minute
        components.second = 0
        
        return cal.date(from: components)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var year: Int {
        return Calendar.current.component(Calendar.Component.year, from: self)
    }
}
