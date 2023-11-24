enum WeatherAPI {
    case current
    case fiveDays
}

extension WeatherAPI: Requestable, KeyAuthenticatable {
    var path: String? {
        guard let APIKey = APIKey else {
            return nil
        }
        
        switch self {
        case .current:
            return "https://api.openweathermap.org/data/2.5/weather?lat=37.715122&lon=126.734086&appid=\(APIKey)"
            
        case .fiveDays:
            return "https://api.openweathermap.org/data/2.5/forecast?lat=37.715122&lon=126.734086&appid=\(APIKey)"
        }
    }
}

