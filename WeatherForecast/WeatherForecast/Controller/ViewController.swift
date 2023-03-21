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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let coordinate = Coordinate(longitude: 10.99, latitude: 44.34)
        fetchWeather(coordinate: coordinate)
        fetchForecast(coordinate: coordinate)

        locationDataManager.delegate = self

        guard locationDataManager.isAuthorized else {
            locationDataManager.requestAuthorization()
            return
        }

        fetchLocation()
    }

    // MARK: - Private

    private func fetchLocation() {
        locationDataManager.requestLocation()
    }

    private func fetchWeather(coordinate: Coordinate) {
        repository.fetchWeather(coordinate: coordinate) { result in
            switch result {
            case .success(let data):
//                print(data)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fetchForecast(coordinate: Coordinate) {
        repository.fetchForecast(coordinate: coordinate) { result in
            switch result {
            case .success(let data):
//                print(data)
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - LocationDataManagerDelegate

extension ViewController: LocationDataManagerDelegate {

    func locationDataManager(_ locationDataManager: LocationDataManager, didUpdateCoordinate coordinate: Coordinate) {
        fetchWeather(coordinate: coordinate)
    }

    func locationDataManager(_ locationDataManager: LocationDataManager,
                             didAuthorized isAuthorized: Bool) {
        guard isAuthorized else { return }
        fetchLocation()
    }

}
