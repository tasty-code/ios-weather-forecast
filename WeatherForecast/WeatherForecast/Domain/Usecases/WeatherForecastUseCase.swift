//
//  WeatherForecastUseCase.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

final class WeatherForecastUseCase {
  
    private let repository: WeatherForecastRepositoryInterface
  
    init(repository: WeatherForecastRepositoryInterface) {
        self.repository = repository
    }
}

extension WeatherForecastUseCase {
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping(WeatherEntitiy) -> Void) {
        guard let lat = lat.doubleToString(),
              let lon = lon.doubleToString() else { return }
        self.repository.fetchWeather(lat: lat, lon: lon) { weatherEntity in
            completion(weatherEntity)
        }
    }
    
    func fetchForecast(lat: Double, lon: Double, completion: @escaping(ForecastEntity) -> Void) {
        guard let lat = lat.doubleToString(),
              let lon = lon.doubleToString() else { return }
        self.repository.fetchForecast(lat: lat, lon: lon) { forecastEntity in
            completion(forecastEntity)
        }
    }
}
