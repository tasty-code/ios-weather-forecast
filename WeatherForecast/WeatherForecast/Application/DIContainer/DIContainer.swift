//
//  DIContainer.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/02.
//

import Foundation

// 여기에 모든 의존성을 조립해서 뷰컨을 탄생시킨다 🌟

final class DIContainer {
    
    func makeWeatherForecastVC() -> WeatherForecastViewController {
        let service = NetworkService()
        let forecastRepository = ForecastRepository(service: service)
        let forecastUsecase = ForecastUseCase(repository: forecastRepository)
        let forecastViewModel = ForecastViewModel(usecase: forecastUsecase)
        let weatherForecastVC = WeatherForecastViewController()
        weatherForecastVC.forecastViewModel = forecastViewModel
        return weatherForecastVC
    }
}
