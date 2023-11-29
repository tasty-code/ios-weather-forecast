import CoreLocation

enum WeatherAPI {
    case current
    case fiveDays
}

extension WeatherAPI: Requestable, KeyAuthenticatable {
    
    private func fetchPath(completion: @escaping (URL?) -> Void) {
        let locationManager = LocationManager()
        var components = URLComponents(string: "https://api.openweathermap.org")
        
        let coordinate = locationManager.fetchCoordinate()
        
        guard let latitude = coordinate?.latitude, let longitude = coordinate?.longitude, let APIKey = APIKey else {
            return
        }
        
        components?.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: "\(APIKey)"),
        ]
        
        switch self {
        case .current:
            components?.path = "/data/2.5/weather"
            completion(components?.url)
        case .fiveDays:
            components?.path = "/data/2.5/forecast"
            completion(components?.url)
        }
        
    }
    
    
    var path: URL? {
        var result: URL?
        fetchPath { url in
            result = url
        }
        return result
    }
}
