//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherForecastViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: WeatherForecastViewModel!
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentLocation()
        binding()
    }
}

// MARK: - Methods

extension WeatherForecastViewController {
    
    private func updateCurrentLocation() {
        let myLocationManager = MyCoreLocationManager.shared
        myLocationManager.delegate = self
    }
    
    private func binding() {

        viewModel.loadWeatherEntity = { [weak self] weatherEntity in
            // ui 업데이트
            print(weatherEntity)
        }

        viewModel.loadForecastEntity = { [weak self] forecastEnitity in
            // ui 업데이트
            print(forecastEnitity)
        }
    }
}

// MARK: - LocationUpdateProtocol Implementation

extension WeatherForecastViewController: LocationUpdateProtocol {
    
    func locationDidUpdateToLocation(location: CLLocation) {
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        viewModel.requestWeatherData(lat: lat, lon: lon)
    }
}
