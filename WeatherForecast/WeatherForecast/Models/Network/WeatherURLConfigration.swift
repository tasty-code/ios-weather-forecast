import Foundation

struct WeatherURLConfigration: APIRequestable {
    var scheme: String = "https"
    var host: String = "api.openweathermap.org"
    var path: String
    var parameters: [String : String]?
    
    init?(coordinate: Coordinate, weatherType: WeatherType, apiKey: String) {
        self.path = "/data/2.5/\(weatherType)"
        
        parameters = [
            "lon": "\(coordinate.longitude)",
            "lat": "\(coordinate.latitude)",
            "appid": apiKey,
            "units": "metric"
        ]
    }
}

enum WeatherType: String {
    case current = "weather"
    case forecast = "forecast"
}
