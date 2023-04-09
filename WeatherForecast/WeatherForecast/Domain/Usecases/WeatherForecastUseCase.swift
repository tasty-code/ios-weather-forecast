//
//  WeatherForecastUseCase.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

protocol WeatherForecastUsecaseInterface {
    func fetchWeather(completion: @escaping(Result<WeatherEntity, Error>) -> Void)
    func fetchForecast(completion: @escaping(Result<ForecastEntity, Error>) -> Void)
}

final class WeatherForecastUseCase: WeatherForecastUsecaseInterface {
    
    private let repository: WeatherForecastRepositoryInterface
    private let coreLocationManager = CoreLocationManager()
    
    private var currentLocation: Location?
    
    init(repository: WeatherForecastRepositoryInterface) {
        self.repository = repository
        coreLocationManager.delegate = self
    }
}

extension WeatherForecastUseCase {
    
    func fetchWeather(completion: @escaping(Result<WeatherEntity, Error>) -> Void) {
        guard let lat = currentLocation?.latitude.doubleToString(),
              let lon = currentLocation?.longitude.doubleToString() else {
            print("Error: unable to get current location.")
            return
        }
        
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
    
    func fetchForecast(completion: @escaping(Result<ForecastEntity, Error>) -> Void) {
        guard let lat = currentLocation?.latitude.doubleToString(),
              let lon = currentLocation?.longitude.doubleToString() else {
            print("Error: unable to get current location.")
            return
        }
        
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

// MARK: - LocationUpdateDelegate Implementation

extension WeatherForecastUseCase: LocationUpdateDelegate {
    
    func locationDidUpdateToLocation(location: Location) {
        currentLocation = location
        self.fetchWeather { _ in }
        self.fetchForecast { _ in }
    }
    
    func locationDidFailWithError(error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
