//
//  CurrentViewModel.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/07.
//

import UIKit

struct CurrentViewModel: WeatherViewModel {
    let information: CurrentInformation
    let temperature: Temperature
}

internal struct CurrentInformation {
    let weatherImage: UIImage
    let locationAddress: String
}

internal struct Temperature {
    let lowest: Double
    let highest: Double
    let current: Double
}
