//
//  WeeklyWeather.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/11/20.
//

import Foundation

struct WeeklyWeather: Decodable {
    var cod: String?
    var message: Int?
    var cnt: Int?
    var list: [List]?
    var city: City?
}

// MARK: - List

struct List: Decodable {
    var dt: Int?
    var main: Main?
    var weather: [Weather]?
    var clouds: Clouds?
    var wind: Wind?
    var visibility: Int?
    var pop: Double?
    var rain: Rain?
    var snow: Snow?
    var sys: List.Sys?
    var dateText: String?
    
    struct Sys: Decodable {
        var pod: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, snow, sys
        case dateText = "dt_txt"
    }
}

// MARK: - City

struct City: Decodable {
    var id: Int?
    var name: String?
    var coord: Coord?
    var country: String?
    var population: Int?
    var timezone: Int?
    var sunrise: Int?
    var sunset: Int?
}


