//
//  CurrentViewModel.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/07.
//

import UIKit

struct CurrentViewModel: WeatherViewModel {
    let currentInformation: CurrentInformation
    let temperature: Temperature
}

internal struct CurrentInformation {
    let currentWeatherIcon: UIImage
    let currentLocationAddress: String
}

internal struct Temperature: Hashable {
    let lowestTemperature: Double
    let highestTemperature: Double
    let currentTemperature: Double
}
