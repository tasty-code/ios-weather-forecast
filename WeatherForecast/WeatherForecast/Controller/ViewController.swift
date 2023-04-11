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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        configureCollectionView()
        configureAutoLayout()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
    }

    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        collectionView.register(WeatherHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeatherHeaderView.id)
        collectionView.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.id)
    }
    
    private func configureAutoLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(view.frame.width, 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 70)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
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

extension ViewController: UICollectionViewDelegate {
    
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
        let current = try await WeatherParser<CurrentWeatherComponents>.parseWeatherData(at: location)
        currentWeather = WeatherData(current: current)
        try await currentWeather?.convertToImage {
            self.currentWeather?.iconImage = $0
        }
    }
    
    private func updateForecastWeather(for location: CurrentCoordinate) async throws {
        let forecast = try await WeatherParser<ForecastWeatherComponents>.parseWeatherData(at: location)
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
