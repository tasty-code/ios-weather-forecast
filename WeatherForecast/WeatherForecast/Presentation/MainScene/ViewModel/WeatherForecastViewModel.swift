//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/04/03.
//

import Foundation
import CoreLocation

final class WeatherForecastViewModel {
    
    private let usecase: WeatherForecastUseCase
    private let coreLocationManager = CoreLocationManager()
    
    var loadWeatherEntity: ((WeatherEntity) -> Void)!
    var loadForecastEntity: ((ForecastEntity) -> Void)!
    
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
        usecase.fetchWeather(lat: lat, lon: lon) { [weak self] weatherEntity in
            self?.loadWeatherEntity(weatherEntity)
        }
    }
    
    func requestFetchData(lat: Double, lon: Double) {
        usecase.fetchForecast(lat: lat, lon: lon) { [weak self] forecastEntity in
            self?.loadForecastEntity(forecastEntity)
        }
    }
}

// MARK: - LocationUpdateDelegate Implementation

extension WeatherForecastViewModel: LocationUpdateDelegate {
    
    func locationDidUpdateToLocation(location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        self.requestWeatherData(lat: lat, lon: lon)
        self.requestFetchData(lat: lat, lon: lon)
    }
}
