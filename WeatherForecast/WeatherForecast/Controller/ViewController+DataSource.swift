//
//  ViewController+DataSource.swift
//  WeatherForecast
//
//  Created by J.E on 2023/04/11.
//

import Foundation
import UIKit

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
