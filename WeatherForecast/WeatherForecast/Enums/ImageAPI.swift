import Foundation

struct ImageAPI: Requestable {
    
    private let iconType: String
    
    init(iconType: String) {
        self.iconType = iconType
    }
    
    var path: URL? {
        let result: URL? = URL(string: "https://openweathermap.org/img/wn/\(iconType)@2x.png")
        return result
    }
}
