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
}

extension WeatherUseCase {
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping(WeatherEntitiy) -> Void) {
        guard let lat = lat.doubleToString(),
              let lon = lon.doubleToString() else { return }
        self.repository.fetchWeather(lat: lat, lon: lon) { weatherEntity in
            completion(weatherEntity)
        }
    }
}
