//
//  WeatherForecast - ForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ForecastViewController: UIViewController {

    // MARK: - Properties

    private let locationManager = CLLocationManager()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setLocationDelegate()
        setUpLocationManager()
    }
}

// MARK: - Methods

extension ForecastViewController {
    private func setLocationDelegate() {
        locationManager.delegate = self
    }

    private func setUpLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension ForecastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }

        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude

        fetchForecastAPI(with: Coordinate(lon: lon, lat: lat))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}

// MARK: - Network

extension ForecastViewController {
    private func fetchWeatherAPI(with coordinate: Coordinate) {
        NetworkService.shared.fetchWeatherAPI(Coordinate(lon: coordinate.lon, lat: coordinate.lat)) { result in
            switch result {
            case .success(let weather):
                print(weather)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchForecastAPI(with coordinate: Coordinate) {
        NetworkService.shared.fetchForecastAPI(Coordinate(lon: coordinate.lon, lat: coordinate.lat)) { result in
            switch result {
            case .success(let forecast):
                print(forecast)
            case .failure(let error):
                print(error)
            }
        }
    }
}
