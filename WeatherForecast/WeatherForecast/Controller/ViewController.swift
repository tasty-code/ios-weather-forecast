//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    
    let locationManager = LocationManager()
    let currentLocationManger = CurrentLocationManager(networkManager: NetworkManager(urlFormatter: WeatherURLFormatter()))
    
    private var mainWeatherView: MainWeatherView!
    private var weeklyWeatherData: WeeklyWeather?
    private var currentWeatherData: CurrentWeather?
    
    override func loadView() {
        super.loadView()
        mainWeatherView = MainWeatherView(delegate: self)
        view = mainWeatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.manager.requestLocation()
        locationManager.currentLocationManager = currentLocationManger
        locationManager.weatherDelgate = self
    }
    
}

extension ViewController: WeatherUpdateDelegate {
    func fetchWeather() {
        currentLocationManger.sendRequest(path: WeatherURL.current.path) { [weak self] (result:Result<CurrentWeather, Error>) in
            switch result {
            case .success(let weather):
                self?.currentWeatherData = weather
                print("\(weather)")
            case .failure(let error):
                print("\(error)")
            }
        }
        currentLocationManger.sendRequest(path: WeatherURL.weekly.path) { [weak self] (result:Result<WeeklyWeather, Error>) in
            switch result {
            case .success(let weather):
                self?.weeklyWeatherData = weather
                DispatchQueue.main.async {
                    self?.mainWeatherView.updateUI()
                }
                print(weather)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cellCount = weeklyWeatherData?.list?.count else {
            return 0
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCell.reuseIdentifier, for: indexPath) as? WeeklyWeatherCell else {
            return WeeklyWeatherCell()
        }
        guard let date = weeklyWeatherData?.list![indexPath.row].dataTime,
              let temperature = weeklyWeatherData?.list![indexPath.row].main?.temperature
        else {
            return WeeklyWeatherCell()
        }
        
        cell.dateLabel.text = DateFormatter.convertTimeToString(with: date)
        cell.temperatureLabel.text = "\(temperature)"
        cell.configure()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CurrentHeaderView.reuseIdentifier, for: indexPath) as? CurrentHeaderView else {
            return CurrentHeaderView()
        }
        
        if let weatherData = currentWeatherData {
            let address = currentLocationManger.getAddress()
            headerView.updateUI(address: address, weather: weatherData)
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
