//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {
    let locationManager = LocationManager()
    let currentLocationManger = CurrentLocationManager(networkManager: NetworkManager(urlFormatter: WeatherURLFormatter()))
    var weeklyWeatherData = WeeklyWeather()
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WeeklyWeatherCell.self, forCellWithReuseIdentifier: WeeklyWeatherCell.identifier)
        
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.manager.requestLocation()
        locationManager.currentLocationManager = currentLocationManger
        locationManager.weatherDelgate = self
        
        collectionViewConfigure()
    }
    
    private func collectionViewConfigure() {
        view.addSubview(collectionView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    private func kelvinToCelsius(_ temperature: Double) -> String {
        return String(format: "%.1f", temperature - 273.15)
    }
    
    private func formattingDate(with dataTime: Int) -> String {
        let time = NSDate(timeIntervalSince1970: TimeInterval(dataTime))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd(E) HH시"
        
        let convertedString = formatter.string(from: time as Date)
        
        return convertedString
        
    }
}

extension ViewController: WeatherUpdateDelegate {
    func fetchWeather() {
        currentLocationManger.sendRequest(path: WeatherURL.current.path) { (result:Result<CurrentWeather, Error>) in
            switch result {
            case .success(let weather):
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
                    self?.collectionView.reloadData()
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
        guard let cellCount = weeklyWeatherData.list?.count else {
            return 0
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCell.identifier, for: indexPath) as? WeeklyWeatherCell else {
            return WeeklyWeatherCell()
        }
        
        
        guard let date = weeklyWeatherData.list![indexPath.row].dataTime else {
            return WeeklyWeatherCell()
        }
        guard let temperature = weeklyWeatherData.list![indexPath.row].main?.temperature else {
            return WeeklyWeatherCell()
        }
        
        
        cell.dateLabel.text = formattingDate(with: date)
        cell.temperatureLabel.text = kelvinToCelsius(temperature)
        
        cell.configure()
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 13)
    }
    
    
}


