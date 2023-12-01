//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let customView: CustomView = CustomView()
    
    private let locationManager: LocationManager
    private let networkManager: NetworkManager
    
    init(locationManager: LocationManager, networkManager: NetworkManager) {
        self.locationManager = locationManager
        self.networkManager = networkManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
    }
    
    private func setDelegate() {
        locationManager.delegate = self
        customView.weatherCollectionView.delegate = self
        customView.weatherCollectionView.dataSource = self
    }
}

extension ViewController: LocationUpdateDelegate {
    func updateWeather(with data: LocationData) {
        let weatherRequest = WeatherRequest(latitude: data.latitude,
                                            longitude: data.longitude,
                                            weatherType: .current)
        networkManager.fetchData(for: weatherRequest) { (result: Result<Current, Error>) in
            switch result {
            case .success(_): break
            case .failure(_): break
            }
        }
        
        let forecastRequest = WeatherRequest(latitude: data.latitude,
                                             longitude: data.longitude,
                                             weatherType: .forecast)
        networkManager.fetchData(for: forecastRequest) { (result: Result<Forecast, Error>) in
            switch result {
            case .success(_): break
            case .failure(_): break
            }
        }
    }
    
    func notifyLocationErrorAlert() {
        let alert = UIAlertController(title: "위치 정보 오류", message: "사용자의 위치 정보를 가져 올 수 없습니다", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier,
                                                            for: indexPath) as? ForecastCell
        else {
            return ForecastCell()
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
            return WeatherHeaderView()
        }
        
        return view
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: view.frame.height / 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: view.frame.height / 10)
    }
}
