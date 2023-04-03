//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class WeatherViewModel {
    
    private let usecase: WeatherUseCase
    var loadEntity: ((WeatherEntitiy) -> Void)!
    
    init(usecase: WeatherUseCase) {
        self.usecase = usecase
    }
}

extension WeatherViewModel {
    
    func requestFetchData(lat: Double, lon: Double) {
        usecase.fetchWeather(lat: lat, lon: lon) { weatherEntity in
            self.loadEntity(weatherEntity)
        }
    }
}
