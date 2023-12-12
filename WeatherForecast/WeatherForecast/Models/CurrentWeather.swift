//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by 김준성 on 11/20/23.
//

import Foundation

struct CurrentWeatherInfo {
    let address: String
    let icon: String
    let mainInfo: MainInfo
}

struct CurrentWeather: Decodable {
    let coordinate: Coordinate
    let weathers: [Weather]
    let base: String
    let mainInfo: MainInfo
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let clouds: Clouds
    let system: Self.System
    let timeOfData: Int
    let id: Int
    let name: String
    let status: Int
    
    
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case weathers = "weather"
        case base
        case mainInfo = "main"
        case visibility
        case wind
        case rain
        case snow
        case clouds
        case system = "sys"
        case timeOfData = "dt"
        case id
        case name
        case status = "cod"
    }
    
    struct System: Decodable {
        let type: Int?
        let id: Int?
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}
