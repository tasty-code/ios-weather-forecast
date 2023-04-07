//
//  Query.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/03/28.
//

import Foundation

enum OpenWeatherParameter {
    static let latitude: String = "lat"
    static let longitude: String = "lon"
    static let measurement: String = "units"
    static let apiKey: String = "appid"
}

enum Measurement {
    static let fahrenheit: String = "imerial"
    static let celsius: String = "metric"
    static let kelvin: String = "standard"
}
