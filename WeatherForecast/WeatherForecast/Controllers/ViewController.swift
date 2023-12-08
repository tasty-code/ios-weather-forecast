//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController, AlertDisplayable {
    
    // MARK: - Properties

    private let customView: CustomView = CustomView()
    
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
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        customView.weatherCollectionView.refreshControl?
            .addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    // MARK: - Private Methods

    private func setDelegate() {
        locationManager.delegate = self
        customView.weatherCollectionView.dataSource = self
    }
    
    private func updateHeaderView(with locationData: LocationData, _ currentWeather: Current?) {
        let indexPaths = customView.weatherCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        guard let currentWeather = currentWeather else {
            displayAlert(title: String(describing: NetworkError.decodingError))
            return
        }
        
        guard let firstIndexPath = indexPaths.first,
              let headerView = customView.weatherCollectionView
            .supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: firstIndexPath) as? WeatherHeaderView
        else {
            return
        }
        guard let iconID = currentWeather.weather.last?.icon else { return }
        networkManager.fetchData(for: IconRequest(id: iconID)) { result in
            switch result {
            case .success(let data):
                let icon = UIImage(data: data)
                DispatchQueue.main.async {
                    headerView.configureUI(with: locationData.address, currentWeather, icon: icon)
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    private func updateCollectionView() {
        let indexPaths = customView.weatherCollectionView.indexPathsForVisibleItems
        
        if indexPaths.isEmpty {
            customView.weatherCollectionView.reloadData()
        } else {
            customView.weatherCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    @objc private func handleRefreshControl() {
        locationManager.requestLocation()
        DispatchQueue.main.async {
            self.customView.weatherCollectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - LocationUpdateDelegate

extension ViewController: LocationUpdateDelegate {
    func updateWeather(with data: LocationData) {
        let weatherRequest = WeatherRequest(latitude: data.latitude,
                                            longitude: data.longitude,
                                            weatherType: .current)
        networkManager.fetchData(for: weatherRequest) { [weak self] result in
            switch result {
            case .success(let undecodedData):
                let currentWeather = try? JSONDecoder().decode(Current.self, from: undecodedData)
                DispatchQueue.main.async {
                    self?.updateHeaderView(with: data, currentWeather)
                }
            case .failure(let error):
                self?.displayAlert(title: String(describing: error))
            }
        }
        
        let forecastRequest = WeatherRequest(latitude: data.latitude,
                                             longitude: data.longitude,
                                             weatherType: .forecast)
        networkManager.fetchData(for: forecastRequest) { [weak self] result in
            switch result {
            case .success(let undecodedData):
                let forecastWeather = try? JSONDecoder().decode(Forecast.self, from: undecodedData)
                self?.forecastModel = forecastWeather
                DispatchQueue.main.async {
                    self?.updateCollectionView()
                }
            case .failure(let error):
                self?.displayAlert(title: String(describing: error))
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
        networkManager.fetchData(for: IconRequest(id: iconID)) { [weak self] result in
            switch result {
            case .success(let data):
                let icon = UIImage(data: data)
                DispatchQueue.main.async {
                    cell.configureUI(with: listData, icon: icon)
                }
            case .failure(let error):
                self?.displayAlert(title: String(describing: error))
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
