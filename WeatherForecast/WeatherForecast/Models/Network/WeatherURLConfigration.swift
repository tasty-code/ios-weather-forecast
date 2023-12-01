import Foundation

struct WeatherURLConfigration: APIRequestable {
    
    var scheme: String = "https"
    var host: String = "api.openweathermap.org"
    var path: String
    var parameters: [String : String]?
    var apiKey: String?
    
    init(coordinate: Coordinate, weatherType: WeatherType.RawValue){
            self.path = "/data/2.5/\(weatherType)"
            self.apiKey = createApiKey(name: "API_KE")
            guard let apiKey = apiKey else { return }
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
