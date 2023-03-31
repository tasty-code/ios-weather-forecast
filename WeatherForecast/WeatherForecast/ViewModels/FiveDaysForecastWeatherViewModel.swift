//
//  FiveDaysForecastWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class FiveDaysForecastWeatherViewModel {
    
    struct FiveDaysForecast: Identifiable {
            let id = UUID()
            var image: UIImage?
            let date: String
            let temperature: Double
        }
}
