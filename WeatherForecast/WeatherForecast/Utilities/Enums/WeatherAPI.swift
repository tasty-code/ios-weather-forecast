import Foundation

enum WeatherAPI {
    case current
    case fiveDays
}

extension WeatherAPI: Requestable, KeyAuthenticatable {
    var path: URL? {
        guard let APIKey = APIKey else {
            return nil
        }
                
        var components = URLComponents(string: "https://api.openweathermap.org")
        
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "37.715122"),
            URLQueryItem(name: "lon", value: "126.734086"),
            URLQueryItem(name: "appid", value: "\(APIKey)"),
        ]
        
        switch self {
        case .current:
            components?.path = "/data/2.5/weather"
            return components?.url
        case .fiveDays:
            components?.path = "/data/2.5/forecast"
            return components?.url
        }
    }
}
