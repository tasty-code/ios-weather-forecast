//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Public property
    let networkManager = NetworkManager()
    let locationManager = LocationManager()

    var weather: Weather? {
        didSet {
            collectionView.reloadData()
        }
    }

    var forecast: Forecast? {
        didSet {
            collectionView.reloadData()
        }
    }

    var weatherIcon: UIImage? {
        didSet {
            collectionView.reloadData()
        }
    }
    var forecastIcons: [String: UIImage]? {
        didSet {
            collectionView.reloadData()
        }
    }

    let dateFormatter = DateFormatter()

    var collectionView = WeatherCollectionView(frame: .zero)
    var collectionViewBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weather_wallpaper")

        return imageView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        
        setUpLocationManager()
        locationManager.delegate = self
        setUpCollectionView()
    }
    
    // MARK: - Private function
    private func setUpLocationManager() {
        locationManager.startUpdatingLocation()
    }

    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundView = collectionViewBackground

        view.addSubview(collectionView)
        collectionView.register(WeatherCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WeatherCollectionViewHeader.headerIdentifier)
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.cellIdentifier)
        configureCollectionViewRestraint()
    }

    private func configureCollectionViewRestraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

