//
//  Weather.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

struct WeatherModel: Codable {
    let coordinate: CurrentCoordinate?
    let weather: [CurrentWeather]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: CurrentWind?
    let clouds: CurrentClouds?
    let date: Int?
    let system: CurrentSys?
    let timezone, id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case weather, base, main, visibility, wind, clouds, timezone, id, name
        case coordinate = "coord"
        case date = "dt"
        case system = "sys"
    }
}

struct CurrentClouds: Codable {
    let all: Int?
}

struct CurrentCoordinate: Codable {
    let lon, lat: Double?
}

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct CurrentSys: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

struct CurrentWeather: Codable {
    let id: Int?
    let main, description, icon: String?
    
}

struct CurrentWind: Codable {
    let speed: Double?
    let deg: Int?
}
