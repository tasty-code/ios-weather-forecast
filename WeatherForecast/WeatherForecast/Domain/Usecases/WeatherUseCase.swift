//
//  WeatherUseCase.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

final class WeatherUseCase {
  
    private let repository: WeatherRepositoryInterface
  
    init(repository: WeatherRepositoryInterface) {
        self.repository = repository
    }
    
    func fetchWeather() {
        self.repository.fetchWeather()
    }
}
