//
//  ViewController+Location.swift
//  WeatherForecast
//
//  Created by J.E on 2023/04/11.
//

import Foundation
import UIKit
import CoreLocation

extension ViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        let coordinate = CurrentCoordinate(of: location)

        Task {
            updateAddress(to: location) {
                $0.formatAddress()
            }

            try await updateCurrentWeather(for: coordinate)
            try await updateForecastWeather(for: coordinate)
            collectionView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(WeatherNetworkError.requestFailed("위치").description)
    }
    
    private func updateCurrentWeather(for location: CurrentCoordinate) async throws {
        let current = try await WeatherParser.parseData(at: location, type: CurrentWeatherComponents.self)
        currentWeather = WeatherData(current: current)
        try await currentWeather?.convertToImage {
            self.currentWeather?.iconImage = $0
        }
    }
    
    private func updateForecastWeather(for location: CurrentCoordinate) async throws {
        let forecast = try await WeatherParser.parseData(at: location, type: ForecastWeatherComponents.self)
        forecastWeather = forecast.list.map { WeatherData(forecast: $0) }

        guard let forecastWeather else {
            return
        }

        for (index, weatherData) in forecastWeather.enumerated() {
            var image: UIImage?
            try await weatherData.convertToImage {
                image = $0
            }

            self.forecastWeather?[index].iconImage = image
        }
    }

    private func updateAddress(to location: CLLocation, _ completion: @escaping (CLPlacemark) -> String?) {
        CLGeocoder().reverseGeocodeLocation(location) { places, _ in
            guard let place = places?.first else {
                return
            }

            self.userAddress = completion(place)
        }
    }
}
