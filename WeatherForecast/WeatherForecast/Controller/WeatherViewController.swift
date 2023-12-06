//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    private let locationDataManager = LocationDataManager()
    private var weatherTodayData: WeatherToday?
    private var weatherForecastData: WeatherForecast?
    private var address: String?
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(
            WeatherCollectionViewCell.self,
            forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier
        )
        view.register(
            WeatherCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: WeatherCollectionHeaderView.identifier
        )
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationDataManager.locationDelegate = self
        
        setUI()
    }
}

// MARK: - LocationDataManagerDelegate

extension WeatherViewController: LocationDataManagerDelegate {
    
    func location(_ manager: LocationDataManager, didLoadCoordinate coordinate: CLLocationCoordinate2D) {
        
        let forecastNetworkManager = WeatherNetworkManager<WeatherForecast>.shared
        forecastNetworkManager.loadWeatherData(type: WeatherType.forecast, coord: coordinate)
        forecastNetworkManager.responseClosure = { data in
            self.weatherForecastData = data
        }
        
        let todayNetworkManager = WeatherNetworkManager<WeatherToday>.shared
        todayNetworkManager.loadWeatherData(type: WeatherType.weatherToday, coord: coordinate)
        todayNetworkManager.responseClosure = { data in
            self.weatherTodayData = data
        }
    }
    
    func loaction(_ manager: LocationDataManager, didCompletePlcamark placemark: CLPlacemark?) {
        guard let placemark else {
            print("can't look up current address")
            return
        }
        
        if
            let locality = placemark.locality,
            let subLocality = placemark.subLocality
        {
            address = "\(locality) \(subLocality)"
        }
    }
    
    func viewRequestLocationSettingAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let openSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let exitAction = UIAlertAction(title: "종료", style: .destructive) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        requestLocationServiceAlert.addAction(openSettingAction)
        requestLocationServiceAlert.addAction(exitAction)
        present(requestLocationServiceAlert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherForecastData?.list.count ?? 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemBlue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        if 
            let timeInterval = weatherForecastData?.list[indexPath.row].dt,
            let icon = weatherForecastData?.list[indexPath.row].weather[0].icon,
            let temperature = weatherForecastData?.list[indexPath.row].main.temp
        {
            let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
            let strDate = dateFormatter.string(from: date as Date)
            cell.dateLabel.text = strDate
            
            let weatherIconURI = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            let url = URL(string: weatherIconURI)
            cell.weatherIconImageView2.load(url: url!) // TODO: 강제 언래핑
            
            let strTemperature = temperatureFormat(temperature)
            cell.temperatureLabel.text = strTemperature
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: WeatherCollectionHeaderView.identifier,
            for: indexPath) as? WeatherCollectionHeaderView else {
            return UICollectionReusableView()
        }
        header.configure()
        header.addressLabel.text = address
        
        if 
            let temperature = weatherTodayData?.main.temp,
            let temperatureMin = weatherTodayData?.main.tempMin,
            let temperatureMax = weatherTodayData?.main.tempMax,
            let icon = weatherTodayData?.weather[0].icon
        {
            let strTemperature = temperatureFormat(temperature)
            let strTemperatureMin = temperatureFormat(temperatureMin)
            let strTemperatureMax = temperatureFormat(temperatureMax)
            
            header.currentTemperatureLabel.text = strTemperature
            header.maxAndMinTemperatureLabel.text = "최저 \(strTemperatureMin) 최고 \(strTemperatureMax)"
        
            let weatherIconURI = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            let url = URL(string: weatherIconURI)
            header.weatherIconImageView.load(url: url!) // TODO: 강제 언래핑
        }
        return header
    }
    
    func temperatureFormat(_ temperature: Double?) -> String {
        let celsius = translateCelsius(kelvin: temperature)
        return String(format: "%.1f°", celsius)
    }
    
    func translateCelsius(kelvin: Double?) -> Double {
        guard let kelvin else { return 0 }
        return kelvin - 273.15
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 120)
    }
}

// MARK: - UICollectionView UI

extension WeatherViewController {
    private func setUI() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
