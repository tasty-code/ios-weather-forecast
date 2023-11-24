extension Model {
    struct CurrentWeather: Decodable {
        let coord: Coord?
        let weather: [Weather]?
        let base: String?
        let main: Main?
        let visibility: Int?
        let wind: Wind?
        let clouds: Clouds?
        let rain: Rain?
        let snow: Snow?
        let dt: Int?
        let sys: Sys?
        let timezone: Int?
        let id: Int?
        let name: String?
        let cod: Int?
    }
    
    struct FiveDaysWeather: Decodable {
        let cod: String?
        let message: Int?
        let cnt: Int?
        let list: [List]?
        let city: City?
    }
}
