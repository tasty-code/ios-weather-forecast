//
//  WeatherForecastUseCase.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

protocol WeatherForecastUsecaseInterface {
    func fetchWeather(lat: Double, lon: Double, completion: @escaping(Result<WeatherEntity, Error>) -> Void)
    func fetchForecast(lat: Double, lon: Double, completion: @escaping(Result<ForecastEntity, Error>) -> Void)
}

final class WeatherForecastUseCase: WeatherForecastUsecaseInterface {
  
    private let repository: WeatherForecastRepositoryInterface
  
    init(repository: WeatherForecastRepositoryInterface) {
        self.repository = repository
    }
}

extension WeatherForecastUseCase {
    
    func fetchWeather(lat: Double, lon: Double, completion: @escaping(Result<WeatherEntity, Error>) -> Void) {
        guard let lat = lat.doubleToString(),
              let lon = lon.doubleToString() else { return }
        self.repository.fetchWeather(lat: lat, lon: lon) { result in
            switch result {
            case .success(let weatherDTO):
                let weatherEntity = weatherDTO.toDomain()
                completion(.success(weatherEntity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchForecast(lat: Double, lon: Double, completion: @escaping(Result<ForecastEntity, Error>) -> Void) {
        guard let lat = lat.doubleToString(),
              let lon = lon.doubleToString() else { return }
        self.repository.fetchForecast(lat: lat, lon: lon) { result in
            switch result {
            case .success(let forecastDTO):
                let forecastEntity = forecastDTO.toDomain()
                completion(.success(forecastEntity))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
