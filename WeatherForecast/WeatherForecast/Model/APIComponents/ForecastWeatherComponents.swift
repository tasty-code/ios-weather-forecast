//
//  ForecastWeatherComponents.swift
//  WeatherForecast
//
//  Created by J.E on 2023/03/14.
//

import Foundation

struct ForecastWeatherComponents: WeatherComposable {
    static var weatherRange: WeatherRange = .forecast

    let list: [WeatherInformation]
    let city: City
}

struct WeatherInformation: Decodable {
    let weather: [Weather]
    let numericalInformation: NumericalWeatherInformation
    let wind: Wind
    let clouds: Clouds
    let rain: Rain?
    let system: System
    let visibility: Int
    let precipitationProbability: Double
    let dataTime: Int

    enum CodingKeys: String, CodingKey {
        case dataTime = "dt"
        case numericalInformation = "main"
        case weather, clouds, wind, visibility, rain
        case precipitationProbability = "pop"
        case system = "sys"
    }
}

struct Rain: Decodable {
    let volumeForLast3Hours: Double

    enum CodingKeys: String, CodingKey {
        case volumeForLast3Hours = "3h"
    }
}

struct City: Decodable {
    let name, country: String
    let coordinate: CurrentCoordinate
    let id, population, timezone, sunrise, sunset: Int

    enum CodingKeys: String, CodingKey {
        case id, name, country, population, timezone, sunrise, sunset
        case coordinate = "coord"
    }
}
