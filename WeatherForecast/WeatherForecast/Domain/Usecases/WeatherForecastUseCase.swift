//
//  WeatherForecastUseCase.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

protocol WeatherForecastUsecaseInterface {
    func getWeather(completion: @escaping(Result<WeatherEntity, Error>) -> Void)
    func getForecast(completion: @escaping(Result<ForecastEntity, Error>) -> Void)
}

final class WeatherForecastUseCase: WeatherForecastUsecaseInterface {
    
    private let repository: WeatherForecastRepositoryInterface
    private let coreLocationManager = CoreLocationManager()
    
    private var currentLocation: Location?
    
    private var fetchWeatherCompletion: ((Result<WeatherEntity, Error>) -> Void)?
    private var fetchForecastCompletion: ((Result<ForecastEntity, Error>) -> Void)?
    
    init(repository: WeatherForecastRepositoryInterface) {
        self.repository = repository
        coreLocationManager.delegate = self
        coreLocationManager.requestLocation()
    }
}

extension WeatherForecastUseCase {
    
    func getWeather(completion: @escaping(Result<WeatherEntity, Error>) -> Void) {
        self.fetchWeatherCompletion = completion
        coreLocationManager.requestLocation()
    }
    
    func getForecast(completion: @escaping(Result<ForecastEntity, Error>) -> Void) {
        self.fetchForecastCompletion = completion
        coreLocationManager.requestLocation()
    }
}

extension WeatherForecastUseCase {
    
    private func fetchWeather(lat: String, lon: String) {
        
        self.repository.fetchWeather(lat: lat, lon: lon) { result in
            switch result {
            case .success(let weatherDTO):
                let weatherEntity = weatherDTO.toDomain()
                self.fetchWeatherCompletion?(.success(weatherEntity))
            case .failure(let error):
                self.fetchWeatherCompletion?(.failure(error))
            }
        }
    }
    
    private func fetchForecast(lat: String, lon: String) {
        
        self.repository.fetchForecast(lat: lat, lon: lon) { result in
            switch result {
            case .success(let forecastDTO):
                let forecastEntity = forecastDTO.toDomain()
                self.fetchForecastCompletion?(.success(forecastEntity))
            case .failure(let error):
                self.fetchForecastCompletion?(.failure(error))
            }
        }
    }
}

// MARK: - LocationUpdateDelegate Implementation

extension WeatherForecastUseCase: LocationUpdateDelegate {
    
    func locationDidUpdateToLocation(location: Location) {
        currentLocation = location
        
        guard let lat = currentLocation?.latitude.doubleToString(),
              let lon = currentLocation?.longitude.doubleToString() else { return }
        
        self.fetchWeather(lat: lat, lon: lon)
        self.fetchForecast(lat: lat, lon: lon)
    }
    
    func locationDidFailWithError(error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
