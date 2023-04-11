//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let locationManager = CLLocationManager()
    private var currentWeather: WeatherData?
    private var forecastWeather: [WeatherData]?
    private var userAddress: String?
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        setUpCollectionView()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
    }

    private func setUpCollectionView() {
        configureCollectionView()
        setUpCollectionViewStyle()
        registerCollectionViewCell()
        view.addSubview(collectionView)
        collectionView.dataSource = self
    }

    private func configureCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = .clear
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = collectionView
    }

    private func setUpCollectionViewStyle() {
        let image = UIImage(named: "bgImage")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        collectionView.backgroundView = imageView
        collectionView.frame = view.frame
    }

    private func registerCollectionViewCell() {
        collectionView.register(WeatherHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeatherHeaderView.id)
        collectionView.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.id)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = forecastWeather?.count else {
            return 40
        }

        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastWeatherCell.id, for: indexPath) as! ForecastWeatherCell
        let data = forecastWeather?[indexPath.row]
        cell.updateWeather(data)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherHeaderView.id, for: indexPath) as! WeatherHeaderView
        header.updateWeather(currentWeather, in: userAddress)

        return header
    }
}

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
