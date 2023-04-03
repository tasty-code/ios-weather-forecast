//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

final class WeatherForecastViewModel {
    
    private let usecase: WeatherForecastUseCase
    
    var loadWeatherEntity: ((WeatherEntitiy) -> Void)!
    var loadForecastEntity: ((ForecastEntity) -> Void)!
    
    init(usecase: WeatherForecastUseCase) {
        self.usecase = usecase
    }
}

extension WeatherForecastViewModel {
    
    func requestWeatherData(lat: Double, lon: Double) {
        usecase.fetchWeather(lat: lat, lon: lon) { weatherEntity in
            self.loadWeatherEntity(weatherEntity)
        }
    }
    
    func requestFetchData(lat: Double, lon: Double) {
        usecase.fetchForecast(lat: lat, lon: lon) { [weak self] forecastEntity in
            self?.loadForecastEntity(forecastEntity)
        }
    }
}
