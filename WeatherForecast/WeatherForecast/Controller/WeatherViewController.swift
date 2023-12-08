//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    private let locationDataManager = LocationDataManager()
    private let forecastDataService = ForecastDataService()
    private let todayDataService = TodayDataService()
    
    private var weatherTodayData: WeatherToday?
    private var weatherForecastData: WeatherForecast?
    private var address: String?
    
    private var backgroundImageView: UIImageView!
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setRefreshControl()
        
        locationDataManager.locationDelegate = self
        forecastDataService.delegate = self
        todayDataService.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func setRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc
    private func handleRefreshControl() {
        collectionView.reloadData()
        DispatchQueue.main.async {
           self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - LocationDataManagerDelegate

extension WeatherViewController: LocationDataManagerDelegate {
    
    func location(_ manager: LocationDataManager, didLoadCoordinate coordinate: CLLocationCoordinate2D) {
        // TODO: 네트워크 downlaodData 할 때 ServiceType(enum)으로 coordinate와 객체 타입을 같이 넘겨줌
        forecastDataService.downloadData(type: .forecast(coordinate: coordinate))
        todayDataService.downloadData(type: .today(coordinate: coordinate))
    }
    
    func loaction(_ manager: LocationDataManager, didCompletePlcamark placemark: CLPlacemark?) {
        guard let placemark else {
            print("can't look up current address")
            return
        }
        
        address = "\(placemark.locality ?? "") \(placemark.subLocality ?? "")"
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
        
        bind(cell: cell, indexPath: indexPath)
        return cell
    }
    
    private func bind(cell: WeatherCollectionViewCell, indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if
            let timeInterval = weatherForecastData?.list[indexPath.row].dt,
            let temperature = weatherForecastData?.list[indexPath.row].main.temp
        {
            let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
            let strDate = dateFormatter.string(from: date as Date)
            cell.dateLabel.text = strDate
            
            let strTemperature = temperatureFormat(temperature)
            cell.temperatureLabel.text = strTemperature
        }
        
        
        guard let icon = weatherForecastData?.list[indexPath.row].weather[0].icon else { return}
        guard let weatherIconURI = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
        let request = URLRequest(url: weatherIconURI)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                   print(error)
                   return
               }
            
            if let data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if indexPath == self.collectionView.indexPath(for: cell) {
                        cell.weatherIconImageView2.image = image
                    }
                }
            }
        }.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: WeatherCollectionHeaderView.identifier,
            for: indexPath) as? WeatherCollectionHeaderView else {
            return UICollectionReusableView()
        }
        if address != nil, weatherTodayData != nil {
            bind(on: header)
        }
        return header
    }
    
    
    func bind(on header: WeatherCollectionHeaderView) {
        header.addressLabel.text = address
        
        let strTemperature = temperatureFormat(weatherTodayData?.main.temp)
        let strTemperatureMin = temperatureFormat(weatherTodayData?.main.tempMin)
        let strTemperatureMax = temperatureFormat(weatherTodayData?.main.tempMax)
        
        header.currentTemperatureLabel.text = strTemperature
        header.maxAndMinTemperatureLabel.text = "최저 \(strTemperatureMin) 최고 \(strTemperatureMax)"
        
        let icon = weatherTodayData?.weather[0].icon
        let weatherIconURI = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        let url = URL(string: weatherIconURI)
        header.weatherIconImageView.load(url: url!) // TODO: 강제 언래핑
    }
    
    func temperatureFormat(_ temperature: Double?) -> String {
        let celsius = translateCelsius(kelvin: temperature)
        return String(format: "%.1f", celsius)
    }
    
    func translateCelsius(kelvin: Double?) -> Double {
        guard let kelvin else { return 0.0 }
        
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

// MARK: - Set ViewController UI

extension WeatherViewController {
    private func setUI() {
        collectionView = {
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
            view.backgroundColor = UIColor(white: 1, alpha: 0)
           view.translatesAutoresizingMaskIntoConstraints = false
           return view
       }()
        
        backgroundImageView  = {
            let imageView = UIImageView(frame: .zero)
            imageView.image = UIImage(named: "yongsan")
            imageView.alpha = 0.7
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        view.addSubview(collectionView)
        view.insertSubview(backgroundImageView, at: 0)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            // collectionView
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            // imageView
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

// MARK: - ForecastDataServiceDelegate, TodayDataServiceDelegate

extension WeatherViewController: ForecastDataServiceDelegate, TodayDataServiceDelegate {
    func forecastData(_ service: ForecastDataService, didDownload data: WeatherForecast) {
        weatherForecastData = data
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func todayData(_ service: TodayDataService, didDownload data: WeatherToday) {
        weatherTodayData = data
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
