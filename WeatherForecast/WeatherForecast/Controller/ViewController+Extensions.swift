//
//  ViewController+Extensions.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/04/05.
//

import UIKit
import CoreLocation

// MARK: - LocationManagerDelegate
extension ViewController: LocationManagerDelegate {
    
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation) {
        networkManager.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        networkManager.callAPI() {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return networkManager.forecastData?.list.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellIdentifier, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.timeLabel.text = networkManager.forecastData?.list[indexPath.section].timeOfDataText
        cell.timeLabel.textColor = .white

        if let temperatureData = networkManager.forecastData?.list[indexPath.section].main.temp {
            cell.temperatureLabel.text = String(format: "%.1f", temperatureData) + "°"
            cell.temperatureLabel.textColor = .white
            cell.temperatureLabel.textAlignment = .center
        }

        cell.tempImage.text = networkManager.forecastData?.list[indexPath.section].weather.first?.icon
        cell.tempImage.textColor = .white
        cell.tempImage.textAlignment = .center

        return cell
    }
}
