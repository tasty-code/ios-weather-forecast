//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController, AlertDisplayable {
    
    // MARK: - Properties
    
    private lazy var weatherView: WeatherView = WeatherView(delegate: self)
    
    private let locationManager: LocationManager
    private let networkManager: NetworkManager
    private let cacheManager: IconCacheManager
    
    private var locationData: LocationData?
    private var currentModel: Current?
    private var forecastModel: Forecast?
    
    // MARK: - Initializer
    
    init(locationManager: LocationManager, networkManager: NetworkManager, cacheManager: IconCacheManager) {
        self.locationManager = locationManager
        self.networkManager = networkManager
        self.cacheManager = cacheManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func loadView() {
        self.view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
    }
    
    // MARK: - Private Methods
    
    private func configureDelegate() {
        locationManager.delegate = self
    }
}

// MARK: - LocationUpdateDelegate

extension WeatherViewController: LocationUpdateDelegate {
    func updateWeather(with locationData: LocationData) {
        weatherView.endRefreshing()
        
        self.locationData = locationData
        
        let weatherRequest = WeatherRequest(latitude: locationData.latitude,
                                            longitude: locationData.longitude,
                                            weatherType: .current)
        networkManager.fetchData(for: weatherRequest) { [weak self] result in
            switch result {
            case .success(let rawData):
                self?.currentModel = try? JSONDecoder().decode(Current.self, from: rawData)
            case .failure(let networkError):
                self?.displayAlert(title: String(describing: networkError))
            }
        }
        
        let forecastRequest = WeatherRequest(latitude: locationData.latitude,
                                             longitude: locationData.longitude,
                                             weatherType: .forecast)
        networkManager.fetchData(for: forecastRequest) { [weak self] result in
            switch result {
            case .success(let rawData):
                self?.forecastModel = try? JSONDecoder().decode(Forecast.self, from: rawData)
                DispatchQueue.main.async {
                    self?.weatherView.reload(with: self?.forecastModel)                    
                }
            case .failure(let networkError):
                self?.displayAlert(title: String(describing: networkError))
            }
        }
    }
    
    func didFailedUpdateLocaion(error: Error) {
        displayAlert(title: "위치 정보 오류", message: "사용자의 위치 정보를 가져올 수 없습니다.\(error.localizedDescription)")
    }
}

// MARK: - WeatherViewDelegate

extension WeatherViewController: WeatherViewDelegate {
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func fetchAddress() -> String? {
        return locationData?.address
    }
    
    func fetchCurrentWeather() -> Current? {
        return currentModel
    }
    
    func fetchForecastWeather() -> Forecast? {
        return forecastModel
    }
    
    func fetchIcon(with iconID: String, completion: @escaping (UIImage) -> Void) {
        if let icon = cacheManager.getIcon(with: iconID) {
            completion(icon)
            return
        }
        
        networkManager.fetchData(for: IconRequest(iconID)) { [weak self] result in
            switch result {
            case .success(let rawData):
                guard let icon = UIImage(data: rawData) else { return }
                self?.cacheManager.store(with: iconID, icon: icon)
                DispatchQueue.main.async {
                    completion(icon)
                }
            case .failure(let error):
                self?.displayAlert(title: String(describing: error))
            }
        }
    }
}

extension WeatherViewController: LocationChangeable {
    func displayLocationInputAlert() {
        let alert = UIAlertController(title: "위치 변경", message: "변경할 좌표를 선택해주세요", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "위도"
            textField.keyboardType = .decimalPad
        }
        
        alert.addTextField { textField in
            textField.placeholder = "경도"
            textField.keyboardType = .decimalPad
        }
        
        let changeAction = UIAlertAction(title: "변경", style: .default) { [weak self] _ in
            guard let latitudeText = alert.textFields?.first?.text,
                  let longitudeText = alert.textFields?.last?.text,
                  let latitude = Double(latitudeText),
                  let longitude = Double(longitudeText)
            else {
                return
            }
            let location = CLLocation(latitude: latitude, longitude: longitude)
            self?.locationManager.convertGeocodeAndUpdate(with: location)
        }
        
        let relocationAction = UIAlertAction(title: "현재 위치로 재설정", style: .default) { [weak self] _ in
            self?.locationManager.requestLocation()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(changeAction)
        alert.addAction(relocationAction)
        alert.addAction(cancelAction)
                
        present(alert, animated: true)
    }
}
