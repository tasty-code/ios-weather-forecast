// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let currentWeather = try? JSONDecoder().decode(CurrentWeather.self, from: jsonData)

// https://openweathermap.org/current#min
import Foundation

// MARK: - CurrentWeather
struct CurrentWeatherDTO: Decodable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let snow: Snow?
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}
extension CurrentWeatherDTO {
    // MARK: - Coord
    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }
    
    // MARK: - Weather
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    // MARK: - Main
    struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
        let pressure: Int
        let humidity: Int
        let tempMin: Double
        let tempMax: Double
        let seaLevel: Int?
        let grndLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case pressure
            case humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    // MARK: - Wind
    struct Wind: Decodable {
        let speed: Double
        let gust: Double?
        let deg: Int?
    }
    
    // MARK: - Clouds
    struct Clouds: Decodable {
        let all: Int
    }
    
    struct Rain: Decodable {
        let oneHour: Int?
        let threeHour: Int?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
    
    struct Snow: Decodable {
        let oneHour: Int?
        let threeHour: Int?
        
        enum CodingKeys: String, CodingKey {
            case oneHour = "1h"
            case threeHour = "3h"
        }
    }
    
    // MARK: - Sys
    struct Sys: Decodable {
        let type: Int
        let id: Int
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}

extension CurrentWeatherDTO: DataTransferable {
    
}
