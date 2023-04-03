//
//  WeatherResponseDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

struct WeatherResponseDTO: Decodable {
    let visibility, dt, timezone, id, cod: Int?
    let base, name: String?
    let coord: Coord?
    let weather: [WeatherElement]
    let main: Main?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let sys: Sys?
}

extension WeatherResponseDTO {
    
    struct Coord: Decodable {
        let lon: Double?
        let lat: Double?
    }
    
    struct Clouds: Decodable {
        let all: Int?
    }
    
    struct Main: Decodable {
        let temp, feelsLike, tempMin, tempMax: Double?
        let pressure, humidity, seaLevel, grndLevel: Int?
        
        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
    }
    
    struct Rain: Decodable {
        let the1H: Double?
        
        enum CodingKeys: String, CodingKey {
            case the1H = "1h"
        }
    }
    
    struct Sys: Decodable {
        let type, id, sunrise, sunset: Int?
        let country: String?
    }
    
    struct WeatherElement: Decodable {
        let id: Int?
        let main, description, icon: String?
    }
    
    struct Wind: Decodable {
        let speed, gust: Double?
        let deg: Int?
    }
}
