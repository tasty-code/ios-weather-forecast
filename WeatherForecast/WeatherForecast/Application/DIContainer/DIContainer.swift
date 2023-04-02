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
        let repository = ForecastRepository(service: service)
        let usecase = ForecastUseCase(repository: repository)
        let viewModel = ForecastViewModel(usecase: usecase)
        let weatherForecastVC = WeatherForecastViewController()
        weatherForecastVC.viewModel = viewModel
        return weatherForecastVC
    }
}
