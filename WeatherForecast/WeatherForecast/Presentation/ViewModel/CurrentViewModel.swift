//
//  CurrentViewModel.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/07.
//

import Foundation

struct CurrentViewModel: Hashable, WeatherViewModel {
    let currentWeatherIcon: Data
    let temperature: Temperature
}

internal struct Temperature: Hashable {
    let lowestTemperature: String
    let highestTemperature: String
    let currentTemperature: String
}
