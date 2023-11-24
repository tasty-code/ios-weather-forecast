import Foundation

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let weather: [Weather]
    let temperature: Temperature
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let time: Int
    let systemData : SystemData
    let timezone, id: Int
    let name: String
    let rain: Rain?
    let snow: Snow?
    
    enum CodingKeys: String, CodingKey {
        case weather, visibility, wind, clouds, timezone, id, name, rain, snow
        case coordinate = "coord"
        case temperature = "main"
        case time = "dt"
        case systemData = "sys"
    }
}










