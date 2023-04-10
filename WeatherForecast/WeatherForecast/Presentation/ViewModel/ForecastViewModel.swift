//
//  ForecastViewModel.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/07.
//

import UIKit

struct ForecastViewModel: WeatherViewModel {
    let weatherImage: UIImage
    let information: ForecastInformation
}

internal struct ForecastInformation {
    let date: Double
    let degree: Double
}
