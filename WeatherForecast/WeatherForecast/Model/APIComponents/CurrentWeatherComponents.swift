//
//  CurrentWeatherComponents.swift
//  WeatherForecast
//
//  Created by J.E on 2023/03/14.
//

import Foundation

struct CurrentWeatherComponents: WeatherComposable {
    static var weatherRange: WeatherRange = .current

    let name: String
    let coordinate: CurrentCoordinate
    let weather: [Weather]
    let numericalInformation: NumericalWeatherInformation
    let wind: Wind
    let clouds: Clouds
    let system: System
    let visibility, timezone, cityID: Int

    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case numericalInformation = "main"
        case system = "sys"
        case cityID = "id"
        case name, weather, visibility, wind, clouds, timezone
    }
}
