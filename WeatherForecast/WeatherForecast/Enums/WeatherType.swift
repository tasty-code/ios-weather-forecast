enum WeatherType: CustomStringConvertible {
    case currentWeather
    case fiveDaysWeahter
    
    var description: String {
        switch self {
            case .currentWeather: "weather"
            case .fiveDaysWeahter: "forecast"
        }
    }
    
    func check() -> DataTransferable.Type {
        switch self {
        case .currentWeather:
            return CurrentWeatherDTO.self
        case .fiveDaysWeahter:
            return FiveDaysWeatherDTO.self
        }
    }
}
