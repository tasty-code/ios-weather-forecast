//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    private let networkManager = NetworkManager()
    private let locationManager = LocationManager()
    private lazy var weatherManager = WeatherDataManager(networkManager: networkManager,
                                                         currentLocationManager: CurrentLocationManager())
    private lazy var weatherImageManager = WeatherImageManager(networkManager: networkManager)
    
    private var mainWeatherView: MainWeatherView!
    
    override func loadView() {
        super.loadView()
        mainWeatherView = MainWeatherView(delegate: self)
        weatherManager.delegate = self
        view = mainWeatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.manager.requestLocation()
        locationManager.currentLocationManager = weatherManager.currentLocationManager
        locationManager.weatherDelgate = weatherManager
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cellCount = weatherManager.weeklyWeather?.list?.count else {
            return 0
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCell.reuseIdentifier, for: indexPath) as? WeeklyWeatherCell else {
            return WeeklyWeatherCell()
        }
        guard let date = weatherManager.weeklyWeather?.list?[indexPath.row].dataTime,
              let temperature = weatherManager.weeklyWeather?.list?[indexPath.row].main?.temperature
        else {
            return WeeklyWeatherCell()
        }
        guard let icon = weatherManager.weeklyWeather?.list?[indexPath.row].weather?[0].icon else { return WeeklyWeatherCell() }
        let convertedDate = DateFormatter.convertTimeToString(with: date)
        
        weatherImageManager.requestImage(name: icon) { image in
            cell.updateUI(date: convertedDate, temperature: "\(temperature)", image: image)
        }
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CurrentHeaderView.reuseIdentifier, for: indexPath) as? CurrentHeaderView else {
            let headerView = CurrentHeaderView()
            headerView.headerViewConfigure()
            return headerView
        }
        
        guard let weatherData = weatherManager.currentWeather else {
            return headerView
        }
        guard let icon = weatherData.weather?.last?.icon else {
            return headerView
        }
        let address = weatherManager.currentLocationManager.getAddress()
        
        weatherImageManager.requestImage(name: icon) { image in
            headerView.updateUI(address: address, weather: weatherData, image: image)
        }
        
        headerView.headerViewConfigure()
        return headerView
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 13)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / 2)
    }
}

extension ViewController: UIUpdatable {
    func updateUI() {
        mainWeatherView.updateUI()
    }
}
