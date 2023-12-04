import Foundation
import CoreLocation

struct WeatherURLConfigration: APIRequestable {
    
    var scheme: String = "https"
    var host: String = "api.openweathermap.org"
    var path: String
    var parameters: [String : String]?
    var apiKey: String?
    
    init(weatherType: WeatherType, coordinate: CLLocationCoordinate2D){
        
        self.path = "/data/2.5/\(weatherType.rawValue)"
        self.apiKey = createApiKey(name: "API_KEY")
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
