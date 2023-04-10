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
        guard let coordinate = locationManager.getCoordinate() else { return }
        Task {
            let weatherData = try await networkManager.callWeatherAPIConcurrency(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let forecastData = try await networkManager.callForecastAPIConcurrency(latitude: coordinate.latitude, longitude: coordinate.longitude)

            weather = weatherData
            forecast = forecastData

            guard let weatherIconString = weather?.weather.first?.icon else { return }
            weatherIcon = try await networkManager.getWeatherIconCuncurrency(weatherStatus: weatherIconString)

            guard let forecastList = forecast?.list else { return }
            forecastIcons = try await networkManager.getForecastIconCuncurrency(forecastList: forecastList)
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

        header.locationLabel.text = locationManager.getAddress()
        header.locationLabel.textColor = .white
        header.locationLabel.font = UIFont.systemFont(ofSize: 15)

        if let tempMin = weather?.main.tempMin, let tempMax = weather?.main.tempMax {
            header.tempMinAndMaxLabel.text = "최저 \(String(format: "%.1f", tempMin))° 최대 \(String(format: "%.1f", tempMax))°"
            header.tempMinAndMaxLabel.textColor = .white
            header.tempMinAndMaxLabel.font = UIFont.systemFont(ofSize: 15)
        }

        if let temp = weather?.main.temp {
            header.tempLabel.text = "\(String(format: "%.1f", temp))°"
            header.tempLabel.textColor = .white
            header.tempLabel.font = UIFont.systemFont(ofSize: 30)
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
            cell.timeLabel.textColor = .white

            cell.temperatureLabel.text = String(format: "%.1f", forecastData.main.temp) + "°"
            cell.temperatureLabel.textColor = .white
            cell.temperatureLabel.textAlignment = .center

            if let forecastIconData = forecastIcons {
                if let forecastStatus = forecastData.weather.first?.icon {
                    cell.tempImage.image = forecastIconData[forecastStatus]
                }
            }
        }

        return cell
    }
}
