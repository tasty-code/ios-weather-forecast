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
        networkManager.callAPI()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellIdentifier, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.indexpathLabel.text = "\(indexPath.section + 1)"

        return cell
    }
}
