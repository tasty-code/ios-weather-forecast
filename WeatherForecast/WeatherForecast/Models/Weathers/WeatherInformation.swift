import Foundation

enum InformationType {
    case weather
    case forecast
    
    var name: String {
        switch self {
            
        case .weather:
           return "weather"
        case .forecast:
           return "forecast"
        }
        
    }
}

struct Coordinate: Decodable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

struct Clouds: Decodable {
    let all: Int
}

struct Rain: Decodable {
    let amountOfRainOneHour, amountOfRainThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case amountOfRainOneHour = "1h"
        case amountOfRainThreeHour = "3h"
    }
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double?
}


struct Snow: Decodable {
    let amountOfSnowOneHour, amountOfSnowThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case amountOfSnowOneHour = "1h"
        case amountOfSnowThreeHour = "3h"
    }
}


struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temperature: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}


struct Sys: Decodable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}
