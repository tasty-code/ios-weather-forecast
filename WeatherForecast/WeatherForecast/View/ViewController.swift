//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {

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

extension ViewController {
    private func setLocationDelegate() {
        locationManager.delegate = self
    }

    private func setUpLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }

        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude

        fetchCurrentWeatherAPI(with: Coordinate(lon: lon, lat: lat))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}

// MARK: - Network

extension ViewController {
    private func fetchCurrentWeatherAPI(with coordinate: Coordinate) {
        APIService.shared.fetchWeatherAPI(coordinate: Coordinate(lon: coordinate.lon, lat: coordinate.lat)) { result in
            switch result {
            case .success(let currentWeather):
                print(currentWeather)
            case .failure(let error):
                print(error)
            }
        }
    }
}
