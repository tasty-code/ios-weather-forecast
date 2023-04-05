//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    private var weatherViewModel = WeatherViewModel()
    private var weatherCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        register()
    }
}

extension WeatherViewController {
    private func configureHierarchy() {
        weatherCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    }
    
    private func register() {
        weatherCollectionView.register(cell: FiveDaysForecastCell.self)
        weatherCollectionView.register(header: CurrentWeatherCell.self)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        weatherViewModel.fiveDaysForecastWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = weatherCollectionView.dequeueReusableCell(withReuseIdentifier: "FiveDaysForecastCell", for: indexPath) as! FiveDaysForecastCell
        let fiveDaysForecasts = weatherViewModel.fiveDaysForecastWeather
        
        let temperature = fiveDaysForecasts[indexPath.row].temperature
        cell.temperatureLabel.text = "\(temperature)°"
        
        let date = fiveDaysForecasts[indexPath.row].date
        let transformedDate = date.changeDateFormat()
        cell.dateLabel.text = transformedDate
        
        let weatherIconImage = fiveDaysForecasts[indexPath.row].image
        cell.weatherIconImage.image = weatherIconImage
        
        return cell
    }
}

