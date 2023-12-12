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
    
    private var forecastModel: Forecast?
    
    // MARK: - Initializer
    
    init(locationManager: LocationManager, networkManager: NetworkManager) {
        self.locationManager = locationManager
        self.networkManager = networkManager
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
        configureRefreshControl()
    }
    
    // MARK: - Private Methods
    
    private func configureDelegate() {
        locationManager.delegate = self
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        weatherView.addRefreshControl(refreshControl: refreshControl)
    }
    
    private func updateHeaderView(with locationData: LocationData, _ currentWeather: Current?) {
        guard let currentWeather = currentWeather else {
            displayAlert(title: String(describing: NetworkError.decodingError))
            return
        }
        guard let headerView = weatherView.headerView else { return }
        
        guard let iconID = currentWeather.weather.last?.icon else { return }
        networkManager.fetchData(for: IconRequest(iconID)) { [weak self] result in
            switch result {
            case .success(let rawData):
                let icon = UIImage(data: rawData)
                DispatchQueue.main.async {
                    headerView.configureUI(with: locationData.address, weather: currentWeather, icon: icon)
                }
            case .failure(let networkError):
                self?.displayAlert(title: String(describing: networkError))
            }
        }
    }
    
    @objc
    private func handleRefreshControl() {
        locationManager.requestLocation()
    }
}

// MARK: - LocationUpdateDelegate

extension WeatherViewController: LocationUpdateDelegate {
    func updateWeather(with locationData: LocationData) {
        weatherView.endRefreshing()
        let weatherRequest = WeatherRequest(latitude: locationData.latitude,
                                            longitude: locationData.longitude,
                                            weatherType: .current)
        networkManager.fetchData(for: weatherRequest) { [weak self] result in
            switch result {
            case .success(let rawData):
                let currentWeather = try? JSONDecoder().decode(Current.self, from: rawData)
                DispatchQueue.main.async {
                    self?.updateHeaderView(with: locationData, currentWeather)
                }
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
                    guard let weatherView = self?.weatherView else { return }
                    weatherView.updateCollectionView()
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

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecastModel = forecastModel else {
            return 0
        }
        return forecastModel.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier,
                                                            for: indexPath) as? ForecastCell
        else {
            return UICollectionViewCell()
        }
        
        guard let forecastModel = forecastModel else {
            return UICollectionViewCell()
        }
        
        let listData = forecastModel.list[indexPath.row]
        guard let iconID = listData.weather.last?.icon else {
            return cell
        }
        networkManager.fetchData(for: IconRequest(iconID)) { [weak self] result in
            switch result {
            case .success(let rawData):
                let icon = UIImage(data: rawData)
                DispatchQueue.main.async {
                    cell.configureUI(with: listData, icon: icon)
                }
            case .failure(let networkError):
                self?.displayAlert(title: String(describing: networkError))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: WeatherHeaderView.reuseIdentifier,
                                                                         for: indexPath) as? WeatherHeaderView
        else {
            return UICollectionReusableView()
        }
        
        return view
    }
}
