//
//  WeatherForecast - WeatherForecastViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherForecastViewController: UIViewController {

    // MARK: - Properties

    private let viewModel = ForecastViewModel()
    private let locationManager = CLLocationManager()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setLocationDelegate()
        setUpLocationManager()
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
}

// MARK: - CLLocationManagerDelegate

extension WeatherForecastViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,   locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }

        let lon = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        viewModel.requestFetchData()
//        fetchForecast(with: Coordinate(lon: lon, lat: lat))
        // CoordniateEntity로 쓰기 🌟
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}

// MARK: - Network

extension WeatherForecastViewController {
    private func fetchWeather(with coordinate: CoordinateEntity) {
//        NetworkService.shared.fetchWeatherAPI(Coordinate(lon: coordinate.lon, lat: coordinate.lat)) { result in
//            switch result {
//            case .success(let weather):
//                print(weather)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }

    private func fetchForecast(with coordinate: CoordinateEntity) {
//        NetworkService.shared.fetchForecastAPI(Coordinate(lon: coordinate.lon, lat: coordinate.lat)) { result in
//            switch result {
//            case .success(let forecast):
//                print(forecast)
//            case .failure(let error):
//                print(error)
//            }
//        }
    }
}
