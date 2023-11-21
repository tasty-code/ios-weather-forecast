import Foundation

struct CurrentWeather: Codable {
    let coordinate: Coordinate
    let weather: [Weather]
    let temperature: Temperature
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let time: Int
    let sys : Sys
    let timezone, id: Int
    let name: String
    let rain: Rain?
    let snow: Snow?
    
    enum CodingKeys: String, CodingKey {
        case weather, visibility, wind, clouds, sys, timezone, id, name, rain, snow
        case coordinate = "coord"
        case temperature = "main"
        case time = "dt"
    }
}










