//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    //MARK: - View Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemPink
        return collectionView
    }()
    
    private lazy var dataService: WeatherForecastDataServiceProtocol = WeatherForecastDataService(dataServiceDelegate: self)
    private let locationManager: LocationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        self.locationManager.delegate = self
        setUpLayout()
        setUpConstraints()
    }
}

// MARK: Autolayout Methods
extension ViewController {
    private func setUpLayout() {
        self.view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: DataServiceDelegate Conformation
extension ViewController: DataServiceDelegate {
    func notifyWeatherModelDidUpdate(dataService: WeatherForecastDataService, model: Decodable?) {
        
    }
    
    func notifyForecastModelDidUpdate(dataService: WeatherForecastDataService, model: Decodable?) {
        
    }
    
    func notifyPlacemarkDidUpdate(dataService: WeatherForecastDataService, currentPlacemark: CLPlacemark?) {
        
    }
}

// MARK: LocationManagerDelegate Conformation
extension ViewController: LocationManagerDelegate {
    func didUpdateLocation(locationManager: LocationManager, location: CLLocation) {
        dataService.fetchData(.weather, location: location)
        dataService.fetchData(.forecast, location: location)
    }
}
