//
//  ForecastResponseDTO.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

struct ForecastResponseDTO: Decodable {
    let cod: String
    let message, cnt: Int
    let list: [List]
    let city: City
}

extension ForecastResponseDTO {
    struct City: Decodable {
        let name, country: String
        let id, population, timezone, sunrise, sunset: Int
        let coord: Coord
    }
    
    struct List: Decodable {
        let dt, visibility: Int
        let pop: Double
        let dtTxt: String
        let main: Main
        let weather: [WeatherElement]
        let clouds: Clouds
        let wind: Wind
        let rain: ForecastRain?
        let sys: ForecastSys
        
        enum CodingKeys: String, CodingKey {
            case dt, main, weather, clouds, wind, visibility, pop, rain, sys
            case dtTxt = "dt_txt"
        }
    }
    
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
    
    struct ForecastRain: Decodable {
        let the3H: Double
        
        enum CodingKeys: String, CodingKey {
            case the3H = "3h"
        }
    }
    
    struct ForecastSys: Decodable {
        let pod: String
    }
}
