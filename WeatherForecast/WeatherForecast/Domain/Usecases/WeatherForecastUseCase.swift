//
//  WeatherForecastUseCase.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

protocol WeatherForecastUsecaseInterface {
    func fetchWeather(lat: Double, lon: Double, completion: @escaping(WeatherEntity) -> Void)
    func fetchForecast(lat: Double, lon: Double, completion: @escaping(ForecastEntity) -> Void)
}

final class WeatherForecastUseCase: WeatherForecastUsecaseInterface {
  
    private let repository: WeatherForecastRepositoryInterface
  
    init(repository: WeatherForecastRepositoryInterface) {
        self.repository = repository
    }
}

extension WeatherForecastUseCase {
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping(WeatherEntity) -> Void) {
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
