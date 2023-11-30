import CoreLocation

enum WeatherAPI {
    case current
    case fiveDays
}

extension WeatherAPI: Requestable, KeyAuthenticatable {
    
    private func fetchPath() -> URL? {
        let locationManager = LocationManager.shared
        var components = URLComponents(string: "https://api.openweathermap.org")
        
        let coordinate = locationManager.fetchCoordinate()
        
        guard let latitude = coordinate?.latitude, let longitude = coordinate?.longitude, let APIKey = APIKey else {
            return nil
        }
        
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
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
    
    var path: URL? {
        let result: URL? = fetchPath()
        return result
    }
}
