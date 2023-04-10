//
//  ForecastViewModel.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/07.
//

import UIKit

struct ForecastViewModel: WeatherViewModel {
    let forecastEmogi: UIImage
    let forecastInformation: ForecastInformation
}

internal struct ForecastInformation: Hashable {
    let forecastDate: Double
    let forecastDegree: Double
}
