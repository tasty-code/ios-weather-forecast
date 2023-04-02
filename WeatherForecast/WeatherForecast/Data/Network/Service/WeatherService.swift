//
//  WeatherService.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(completion: @escaping (Result<WeatherResponseDTO, Error>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    let repository = WeatherRepository()

    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func fetchWeather(completion: @escaping (Result<WeatherResponseDTO, Error>) -> Void) {
        repository.fetchWeather(completion: completion)
    }
}
