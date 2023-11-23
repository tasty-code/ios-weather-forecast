//
//  Current.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/20/23.
//

import Foundation

// MARK: - Current

struct Current: Decodable {
    let coord: CurrentCoordinate
    let weather: [CurrentWeather]
    let main: WeatherCondition
    let visibility: Int
    let wind: CurrentWind
    let rain: CurrentRain?
    let clouds: CurrentClouds
    let dt: Int
    let sys: System
    let timezone, id: Int
    let name: String
}

// MARK: - CurrentClouds

struct CurrentClouds: Decodable {
    let all: Int
}

// MARK: - CurrentCoordinate

struct CurrentCoordinate: Decodable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: - WeatherCondition

struct WeatherCondition: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?
    
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

// MARK: - CurrentWeather

struct CurrentRain: Decodable {
    let amountOfRainOneHour: Double?
    let amountOfRainThreeHour: Double?
    
    enum CodingKeys: String, CodingKey {
        case amountOfRainOneHour = "1h"
        case amountOfRainThreeHour = "3h"
    }
}

// MARK: - System

struct System: Decodable {
    let country: String
    let sunrise, sunset: Int
}

// MARK: - CurrentWeather

struct CurrentWeather: Decodable {
    let id: Int
    let main, description, icon: String
}

// MARK: - CurrentWind

struct CurrentWind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
