//
//  WeatherEntitiy.swift
//  WeatherForecast
//
//  Created by Bora Yang on 2023/03/14.
//

import Foundation

struct WeatherEntity {
    let weather: [WeatherElementEntity]
    let main: MainWeatherEntity?
}

struct MainWeatherEntity {
    let temp: Double?
}

struct WeatherElementEntity {
    let id: Int?
    let main, description, icon: String?
}
