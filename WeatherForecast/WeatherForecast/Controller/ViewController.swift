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
    
    let dateFormatter = DateFormatter()

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

    // MARK: - Private property
    private var refreshControl = UIRefreshControl()
    
    private var collectionView = WeatherCollectionView(frame: .zero)
    
    private var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "weather_wallpaper")

        return imageView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        backgroundViewConfiguration()
        
        view.addSubview(collectionView)
        setUpCollectionView()
        collectionViewConfiguration()
        
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        
        locationManager.delegate = self
        setUpLocationManager()
    }
    
    // MARK: - Private function
    private func setUpLocationManager() {
        locationManager.startUpdatingLocation()
    }

    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0, green: 0.0, blue: 0.0, alpha: 0)
        
        collectionView.register(WeatherCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: WeatherCollectionViewHeader.headerIdentifier)
        collectionView.register(WeatherCollectionViewCell.self,
                                forCellWithReuseIdentifier: WeatherCollectionViewCell.cellIdentifier)
        
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        locationManager.startUpdatingLocation()
        refreshControl.endRefreshing()
    }

    private func collectionViewConfiguration() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func backgroundViewConfiguration() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}

