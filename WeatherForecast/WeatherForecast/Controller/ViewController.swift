//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    private let locationManager = CLLocationManager()
    var currentWeather: WeatherData?
    var forecastWeather: [WeatherData]?
    var userAddress: String?
    private(set) var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        setUpCollectionView()
        configureRefreshControl()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
    }

    private func setUpCollectionView() {
        configureCollectionView()
        setUpCollectionViewStyle()
        registerCollectionViewCell()
        view.addSubview(collectionView)
        collectionView.dataSource = self
    }

    private func configureCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = .clear
        configuration.headerMode = .supplementary
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = collectionView
    }

    private func setUpCollectionViewStyle() {
        let image = UIImage(named: "bgImage")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        collectionView.backgroundView = imageView
        collectionView.frame = view.frame
    }

    private func registerCollectionViewCell() {
        collectionView.register(WeatherHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeatherHeaderView.id)
        collectionView.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.id)
    }
    
    private func configureRefreshControl() {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        collectionView.refreshControl = control
    }
    
    @objc private func refreshCollectionView() {
        locationManager.requestLocation()
    }
}

