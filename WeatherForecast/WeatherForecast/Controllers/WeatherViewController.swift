//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController, UICollectionViewDelegate {
    private let weatherManager = WeatherManager()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        
        configureCollectionView()
        configureRefreshControl()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        collectionView.register(WeatherTimeViewCell.self, forCellWithReuseIdentifier: WeatherTimeViewCell.identifier)
        
        collectionView.register(CurrentWeatherCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentWeatherCollectionReusableView.identifier)
        
        view.addSubview(collectionView)
    }
    
    private func configureRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        weatherManager.refreshData()
    }
}

// MARK: - CollectionView Layout

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 100)
    }
}

// MARK: - CollectionView Data Flow

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CurrentWeatherCollectionReusableView.identifier,
            for: indexPath) as? CurrentWeatherCollectionReusableView else {
            return UICollectionReusableView()
        }
    
        guard let addressLabel = weatherManager.currentAddress,
              let weather = weatherManager.cacheData[.weather] as? CurrentWeather else {
                return header
        }
        
        let minTemp = weather.main.tempMin
        let maxTemp = weather.main.tempMax
        let temp = weather.main.temp
        
        header.setAddressLabel(addressLabel)
        header.setMaxMinTempertureLabel(max: maxTemp, min: minTemp)
        header.setTempertureLabel(temp)
        
        guard let iconId = weather.weather.first?.icon else {
            return header
        }
        
        guard let cachedIcon = weatherManager.iconService.getIcon(by: iconId) else {
            return header
        }
        
        header.setMainIcon(cachedIcon as! Data)
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecast = weatherManager.cacheData[.forecast] as? FiveDayForecast else { return 40 }
        return forecast.cnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherTimeViewCell.identifier, for: indexPath) as? WeatherTimeViewCell else {
            return UICollectionViewCell()
        }
        
        
        guard let forecast = weatherManager.cacheData[.forecast] as? FiveDayForecast else { return cell }
        cell.setTimeLabel(forecast.list[indexPath.row].dateTimeText)
        cell.setTemperatureLabel(forecast.list[indexPath.row].main.temp!)
        
        guard let weather = forecast.list[indexPath.row].weather.first else { return cell }
        guard let cachedIcon = weatherManager.iconService.getIcon(by: weather.icon) else {
            return cell
        }
        
        cell.setIconImage(cachedIcon as! Data, temp: indexPath.row)
        
        cell.addBorder(1, color: .systemGray, alpha: 0.5)
        
        return cell
    }
}

// MARK: - weatherManager Delegate

extension WeatherViewController: WeatherManagerDelegate {
    func updateWeatherDisplay() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func refreshWeatherDisplay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func showAlertWhenNoAuthorization() {
        let alert = UIAlertController(title: nil, message: "설정>앱>위치에서 변경 가능", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "설정으로 이동", style: .default)  { _ in
            guard let url = URL(string:UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        let noAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}
