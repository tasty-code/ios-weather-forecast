//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

final class WeatherForecastViewModel {
    
    private let usecase: WeatherForecastUseCase
    
    var loadWeatherEntity: ((Result<WeatherEntity, Error>) -> Void)?
    var loadForecastEntity: ((Result<ForecastEntity, Error>) -> Void)?
    
    init(usecase: WeatherForecastUseCase) {
        self.usecase = usecase
    }
}

extension WeatherForecastViewModel {
    
    func requestWeatherData() {
        usecase.getWeather { [weak self] result in
            self?.loadWeatherEntity?(result)
        }
    }
    
    func requestForecastData() {
        usecase.getForecast { [weak self] result in
            self?.loadForecastEntity?(result)
        }
    }
}
