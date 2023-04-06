//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation

final class WeatherForecastViewModel {
    
    private let usecase: WeatherForecastUseCase
    private let coreLocationManager = CoreLocationManager()
    
    var loadWeatherEntity: ((WeatherEntity) -> Void)?
    var loadForecastEntity: ((ForecastEntity) -> Void)?
    
    init(usecase: WeatherForecastUseCase) {
        self.usecase = usecase
        self.updateCurrentLocation()
    }
    
    private func updateCurrentLocation() {
        coreLocationManager.delegate = self
    }
}

extension WeatherForecastViewModel {
    
    func requestWeatherData(lat: Double, lon: Double) {
        usecase.fetchWeather(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let weatherEntity):
                self?.loadWeatherEntity?(weatherEntity)
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
    
    func requestFetchData(lat: Double, lon: Double) {
        usecase.fetchForecast(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case .success(let forecastEntity):
                self?.loadForecastEntity?(forecastEntity)
            case .failure(let error):
                print("Error fetching weather data: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - LocationUpdateDelegate Implementation

extension WeatherForecastViewModel: LocationUpdateDelegate {
    
    func locationDidUpdateToLocation(location: Location) {
        let lat = location.latitude
        let lon = location.longitude
        self.requestWeatherData(lat: lat, lon: lon)
        self.requestFetchData(lat: lat, lon: lon)
    }
    
    func locationDidFailWithError(error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
