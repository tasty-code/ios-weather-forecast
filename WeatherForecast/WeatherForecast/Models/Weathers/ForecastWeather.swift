import Foundation

struct ForecastWeather: Decodable {
    let cnt: Int
    let fiveDaysForecast: [DayCondition]
    let city: City
    
    enum CodingKeys: String, CodingKey {
        case cnt, city
        case fiveDaysForecast = "list"
    }
}

struct City: Decodable {
    let id: Int
    let name: String
    let coordinate: Coordinate
    let country: String
    let population, timezone, sunrise, sunset: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, country, population, timezone, sunrise, sunset
        case coordinate = "coord"
    }
}

struct DayCondition: Decodable {
    let dt: Int
    let temperature: Temperature
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let probabilityOfPrecipitation: Double
    let dtTxt: String
    let rain: Rain?
    let snow: Snow?
    
    enum CodingKeys: String, CodingKey {
        case dt, weather, clouds, wind, visibility, rain, snow
        case dtTxt = "dt_txt"
        case temperature = "main"
        case probabilityOfPrecipitation = "pop"
    }
}

