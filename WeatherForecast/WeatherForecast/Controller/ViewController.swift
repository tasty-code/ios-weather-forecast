//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties

    private let repository = OpenWeatherRepository(
        deserializer: JSONDesirializer(),
        service: OpenWeatherService()
    )

    private let locationDataManager = LocationDataManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let coordinate = Coordinate(longitude: 10.99, latitude: 44.34)
        fetchWeather(coordinate: coordinate)
        fetchForecast(coordinate: coordinate)

        locationDataManager.requestAuthorization()
        locationDataManager.requestLocation { location in
            print(location?.coordinate.latitude, location?.coordinate.longitude)
        }
    }

    // MARK: - Private

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
