//
//  ViewController+Extensions.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/04/05.
//

import UIKit
import CoreLocation

extension ViewController: LocationManagerDelegate {
    func fetchData() {
        guard let coordinate = locationManager.coordinate else { return }
        Task {
            weather = try await networkManager.callWeatherAPI(latitude: coordinate.latitude, longitude: coordinate.longitude)
            forecast = try await networkManager.callForecastAPI(latitude: coordinate.latitude, longitude: coordinate.longitude)

            guard let weatherIconString = weather?.weather.first?.icon else { return }
            weatherIcon = try await networkManager.callWeatherIconAPI(weatherStatus: weatherIconString)

            guard let forecastList = forecast?.list else { return }
            forecastIcons = try await networkManager.callForecastIconAPI(forecastList: forecastList)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecast?.list.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: WeatherCollectionViewHeader.headerIdentifier, for: indexPath) as? WeatherCollectionViewHeader else {
            return UICollectionReusableView()
        }

        header.weatherImage.image = weatherIcon

        header.locationLabel.text = locationManager.address

        if let tempMin = weather?.main.tempMin, let tempMax = weather?.main.tempMax {
            header.tempMinAndMaxLabel.text = "최저 \(String(format: "%.1f", tempMin))° 최대 \(String(format: "%.1f", tempMax))°"
        }

        if let temp = weather?.main.temp {
            header.tempLabel.text = "\(String(format: "%.1f", temp))°"
        }

        return header
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellIdentifier, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let forecastData = forecast?.list[indexPath.row] {
            let conversionTimeDataToDate = Date(timeIntervalSinceReferenceDate: TimeInterval(forecastData.timeOfData))

            cell.timeLabel.text = dateFormatter.string(from: conversionTimeDataToDate)

            cell.temperatureLabel.text = String(format: "%.1f", forecastData.main.temp) + "°"

            if let forecastIconData = forecastIcons {
                if let forecastStatus = forecastData.weather.first?.icon {
                    cell.tempImage.image = forecastIconData[forecastStatus]
                }
            }
        }

        return cell
    }
}
