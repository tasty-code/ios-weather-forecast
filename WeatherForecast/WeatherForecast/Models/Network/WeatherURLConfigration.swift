import Foundation

struct WeatherURLConfigration: APIRequestable {
    
    var scheme: String = "https"
    var host: String = "api.openweathermap.org"
    var path: String
    var parameters: [String : String]?
    var apiKey: String {
        guard let apiKey = createApiKey(name: "API_KEY") else { return "" }
        return apiKey
    }
    
    init(coordinate: Coordinate, weatherType: WeatherType.RawValue) {
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
