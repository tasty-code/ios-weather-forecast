//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController, AlertDisplayable {
    
    // MARK: - Properties

    private let weatherView: WeatherView = WeatherView()
    
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
        weatherView.weatherCollectionView.refreshControl?
            .addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    // MARK: - Private Methods

    private func configureDelegate() {
        locationManager.delegate = self
        weatherView.weatherCollectionView.dataSource = self
    }
    
    private func updateHeaderView(with locationData: LocationData, _ currentWeather: Current?) {
        let indexPaths = weatherView.weatherCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        guard let currentWeather = currentWeather else {
            displayAlert(title: String(describing: NetworkError.decodingError))
            return
        }
        
        guard let firstIndexPath = indexPaths.first,
              let headerView = weatherView.weatherCollectionView
            .supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: firstIndexPath) as? WeatherHeaderView
        else {
            return
        }
        guard let iconID = currentWeather.weather.last?.icon else { return }
        networkManager.fetchData(for: IconRequest(iconID)) { result in
            switch result {
            case .success(let rawData):
                let icon = UIImage(data: rawData)
                DispatchQueue.main.async {
                    headerView.configureUI(with: locationData.address, weather: currentWeather, icon: icon)
                }
            case .failure(let networkError): print(networkError)
            }
        }
    }
    
    private func updateCollectionView() {
        let indexPaths = weatherView.weatherCollectionView.indexPathsForVisibleItems
        
        if indexPaths.isEmpty {
            weatherView.weatherCollectionView.reloadData()
        } else {
            weatherView.weatherCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    @objc private func handleRefreshControl() {
        locationManager.requestLocation()
        DispatchQueue.main.async {
            self.weatherView.weatherCollectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - LocationUpdateDelegate

extension ViewController: LocationUpdateDelegate {
    func updateWeather(with locationData: LocationData) {
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
                    self?.updateCollectionView()
                }
            case .failure(let networkError):
                self?.displayAlert(title: String(describing: networkError))
            }
        }
    }
    
    func notifyLocationErrorAlert() {
        displayAlert(title: "위치 정보 오류", message: "사용자의 위치 정보를 가져올 수 없습니다.")
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
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
