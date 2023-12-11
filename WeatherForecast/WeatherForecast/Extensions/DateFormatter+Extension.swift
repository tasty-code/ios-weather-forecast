import Foundation

extension DateFormatter {
    
    convenience init(date: NSDate) {
        self.init()
        
        self.locale = Locale(identifier:"ko_KR")
        self.dateFormat = "MM/dd(E) HH시"
    }
    
    static func toString(by date: Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(date))
        let dateFormatter = DateFormatter(date: date)
        let dateString = dateFormatter.string(from: date as Date)
        
        return dateString
    }
}
