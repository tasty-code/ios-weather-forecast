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
        let repository = WeatherForecastRepository(service: service)
        let usecase = WeatherForecastUseCase(repository: repository)
        let viewmodel = WeatherForecastViewModel(usecase: usecase)
        let weatherForecastVC = WeatherForecastViewController()
        weatherForecastVC.viewModel = viewmodel
        return weatherForecastVC
    }
}
