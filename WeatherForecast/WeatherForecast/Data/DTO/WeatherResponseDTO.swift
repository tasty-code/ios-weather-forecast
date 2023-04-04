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
    let coord: CoordDTO?
    let weather: [WeatherElementDTO]
    let main: MainDTO?
    let wind: WindDTO?
    let rain: RainDTO?
    let clouds: CloudsDTO?
    let sys: SysDTO?
}

struct CoordDTO: Decodable {
    let lon: Double?
    let lat: Double?
}

struct CloudsDTO: Decodable {
    let all: Int?
}

struct MainDTO: Decodable {
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

struct RainDTO: Decodable {
    let the1H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct SysDTO: Decodable {
    let type, id, sunrise, sunset: Int?
    let country: String?
}

struct WeatherElementDTO: Decodable {
    let id: Int?
    let main, description, icon: String?
}

struct WindDTO: Decodable {
    let speed, gust: Double?
    let deg: Int?
}
