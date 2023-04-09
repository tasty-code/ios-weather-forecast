//
//  ForecastViewModel.swift
//  WeatherForecast
//
//  Created by 박재우 on 2023/04/07.
//

import Foundation

struct ForecastViewModel: Hashable, WeatherViewModel {
    let forecastEmogi: Data
    let forecastInformation: ForecastInformation
}

internal struct ForecastInformation: Hashable {
    let forecastDate: String
    let forecastDegree: String
}
