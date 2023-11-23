extension Decodable {
    static var weatherType: String? {
        if self == Model.CurrentWeather.self {
            return "weather"
        } else if self == Model.FiveDaysWeather.self {
            return "forecast"
        } else {
            return nil
        }
    }
}
