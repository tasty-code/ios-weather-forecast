//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {

    // MARK: - Properties

    private let repository = OpenWeatherRepository(
        deserializer: JSONDesirializer(),
        service: NetworkService()
    )

    private let locationDataManager = LocationDataManager()
    private let addressManager = AddressManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLocationDataManager()
    }

    // MARK: - Private

    private func configureLocationDataManager() {
        locationDataManager.delegate = self

        if !locationDataManager.isAuthorized {
            locationDataManager.requestAuthorization()
        }
    }

    private func fetchLocation() {
        locationDataManager.requestLocation()
    }

    private func fetchWeather(coordinate: Coordinate) {
        repository.fetchWeather(coordinate: coordinate) { result in
            switch result {
            case .success(let currentWeather):
                print(currentWeather.weathers.first?.description ?? "")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fetchForecast(coordinate: Coordinate) {
        repository.fetchForecast(coordinate: coordinate) { result in
            switch result {
            case .success(let forecast):
                print(forecast.forecastDatas.first?.weathers.first?.description ?? "")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - LocationDataManagerDelegate

extension ViewController: LocationDataManagerDelegate {

    func locationDataManager(_ locationDataManager: LocationDataManager,
                             didAuthorized isAuthorized: Bool) {
        guard isAuthorized else { return }
        fetchLocation()
    }

    func locationDataManager(_ locationDataManager: LocationDataManager,
                             didUpdateLocation location: CLLocation) {
        addressManager.fetchAddress(of: location) { placemark in
            guard let placemark else { return }

            print(placemark.country ?? "",
                  placemark.administrativeArea ?? "",
                  placemark.locality ?? "",
                  placemark.name ?? "")
        }

        guard let coordinate = locationDataManager.currentCoordinate else { return }

        fetchWeather(coordinate: coordinate)
        fetchForecast(coordinate: coordinate)
    }
}
