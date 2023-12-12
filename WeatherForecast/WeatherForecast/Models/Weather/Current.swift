//
//  Current.swift
//  WeatherForecast
//
//  Created by 김경록 on 11/20/23.
//

import Foundation

// MARK: - Current

struct Current: Decodable {
    let coordinate: CurrentCoordinate
    let weather: [CurrentWeather]
    let main: WeatherCondition
    let wind: CurrentWind
    let rain: CurrentRain?
    let clouds: CurrentClouds
    let system: System
    let visibility: Int
    let timeOfDataCalculation: Int
    let timezone, id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case timeOfDataCalculation = "dt"
        case system = "sys"
        case weather,main,wind,rain,clouds,visibility,timezone,id,name
    }
}

// MARK: - CurrentCoordinate

struct CurrentCoordinate: Decodable {
    let longitude, latitude: Double
    
    enum CodingKeys: String, CodingKey {
        case longitude = "lon"
        case latitude = "lat"
    }
}

// MARK: - CurrentWeather

struct CurrentWeather: Decodable {
    let id: Int
    let main, description, icon: String
}

// MARK: - WeatherCondition

struct WeatherCondition: Decodable {
    let temperature, feelsLike, minimumTemperature, maximumTemperature: Double
    let pressure, humidity: Int
    let seaLevel, groundLevel: Int?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case minimumTemperature = "temp_min"
        case maximumTemperature = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}

// MARK: - CurrentWind

struct CurrentWind: Decodable {
    let speed: Double
    let degrees: Int
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed,gust
        case degrees = "deg"
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

// MARK: - CurrentClouds

struct CurrentClouds: Decodable {
    let all: Int
}

// MARK: - System

struct System: Decodable {
    let country: String
    let sunrise, sunset: Int
}
