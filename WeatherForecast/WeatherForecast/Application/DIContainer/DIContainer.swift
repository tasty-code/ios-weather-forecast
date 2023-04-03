//
//  DIContainer.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/02.
//

import Foundation

final class DIContainer {
    
    func makeWeatherForecastVC() -> WeatherForecastViewController {
        let service = NetworkService()
        let weatherRepository = WeatherRepository(service: service)
        let forecastRepository = ForecastRepository(service: service)
        let weatherUsecase = WeatherUseCase(repository: weatherRepository)
        let forecastUsecase = ForecastUseCase(repository: forecastRepository)
        let weatherViewModel = WeatherViewModel(usecase: weatherUsecase)
        let forecastViewModel = ForecastViewModel(usecase: forecastUsecase)
        let weatherForecastVC = WeatherForecastViewController()
        weatherForecastVC.forecastViewModel = forecastViewModel
        weatherForecastVC.weatherViewModel = weatherViewModel
        return weatherForecastVC
    }
}
