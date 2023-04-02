//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherForecastViewController: UIViewController {

    // MARK: - Properties

    var viewModel: ForecastViewModel!
    private let locationManager = CLLocationManager()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationDelegate()
        setUpLocationManager()
        binding()
    }
}

// MARK: - Methods

extension WeatherForecastViewController {
    private func setLocationDelegate() {
        locationManager.delegate = self
    }

    private func setUpLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func binding() {
        viewModel.loadEntity = { [weak self] forecastEnitity in
            // ui 업데이트
            print(forecastEnitity)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherForecastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }

        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        viewModel.requestFetchData(lon: lon, lat: lat)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
