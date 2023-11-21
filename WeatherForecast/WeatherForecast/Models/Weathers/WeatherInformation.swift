import Foundation

struct Coordinate: Codable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Clouds: Codable {
    let all: Int
}

struct Rain: Codable {
    let amountOfRainOneHour, amountOfRainThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case amountOfRainOneHour = "1h"
        case amountOfRainThreeHour = "3h"
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}


struct Snow: Codable {
    let amountOfSnowOneHour, amountOfSnowThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case amountOfSnowOneHour = "1h"
        case amountOfSnowThreeHour = "3h"
    }
}


struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temperature: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
    }
}


struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}
