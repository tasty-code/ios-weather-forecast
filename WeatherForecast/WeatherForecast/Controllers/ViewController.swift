//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let weatherManager = WeatherManager()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        
        collectionView.register(WeatherTimeViewCell.self, forCellWithReuseIdentifier: WeatherTimeViewCell.identifier)
        collectionView.register(CurrentWeatherCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentWeatherCollectionReusableView.identifier)
        
        weatherManager.delegate = self
        weatherManager.startLocationUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 100)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentWeatherCollectionReusableView.identifier, for: indexPath) as? CurrentWeatherCollectionReusableView else { return UICollectionReusableView() }
            
            guard let addressLabel = weatherManager.currentAddress, let weather = weatherManager.cacheData[.weather] as? CurrentWeather else { return header }
            let minTemp = weather.main.tempMin
            let maxTemp = weather.main.tempMax
            let temp = weather.main.temp
            
            header.setAddressLabel(addressLabel)
            header.setMaxMinTempertureLabel(max: maxTemp, min: minTemp)
            header.setTempertureLabel(temp)
            
            if let icon = weather.weather.first?.icon {
                DispatchQueue.global().async {
                    header.setMainIcon(icon)
                }
            }
            
            return header
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecast = weatherManager.cacheData[.forecast] as? FiveDayForecast else { return 40 }
        return forecast.cnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherTimeViewCell.identifier, for: indexPath) as? WeatherTimeViewCell else {
            return UICollectionViewCell()
        }
        
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.red.cgColor

        guard let forecast = weatherManager.cacheData[.forecast] as? FiveDayForecast else { return cell }
        cell.setTimeLabel(forecast.list[indexPath.row].dateTimeText)
        cell.setTemperatureLabel(forecast.list[indexPath.row].main.temp!)
        
        guard let weather = forecast.list[indexPath.row].weather.first else { return cell }
        DispatchQueue.global().async {
            cell.setIconImage(weather.icon)
        }
        
        return cell
    }
}
extension ViewController: UICollectionViewDelegate {}

extension ViewController: WeatherManagerDelegate {
    
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
    
    func updateCollectionViewUI() {
        self.collectionView.reloadData()
    }
}
