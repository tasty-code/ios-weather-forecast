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
        let lat = URLQueryItem(name: "lat", value: "37.715122")
        let lon = URLQueryItem(name: "lon", value: "126.734086")
        let appid = URLQueryItem(name: "appid", value: "\(APIKey)")
        components?.queryItems = [lat, lon, appid]
        
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
