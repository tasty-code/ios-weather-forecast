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

    var collectionView = WeatherCollectionView(frame: .zero)
    var collectionViewBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weather_wallpaper")

        return imageView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        setUpCollectionView()
        setUpLocationManager()
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

