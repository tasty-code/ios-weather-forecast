//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let collectionReusableHeaderViewHeightRatio: CGFloat = 8
        static let collectionViewCellHeightRatio: CGFloat = 20
        static let collectionViewDefaultPadding: CGFloat = 14
    }
    
    // MARK: - View Components
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "RootViewBackground")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .white
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        return collectionView
    }()
    
    // MARK: - Dependencies
    private lazy var weatherDataService: DataDownloadable = WeatherDataService(dataServiceDelegate: self)
    private lazy var forecastDataService: DataDownloadable = ForecastDataService(dataServiceDelegate: self)
    private let locationManager = LocationManager()
    
    // MARK: - Properties
    private var weatherModel: WeatherModel? = nil
    private var forecastModel: ForecastModel? = nil
    private var currentPlacemark: CLPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        collectionView.register(CollectionReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableHeaderView.reuseIdentifier)
        setUpLayout()
        setUpConstraints()
    }
}

// MARK: Private Methods
extension ViewController {
    @objc private func refreshCollectionView(_ location: CLLocation) {
        locationManager.requestLocation()
        
        DispatchQueue.main.async {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: UICollectionViewDelegate, DataSource Confirmation
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionCount = forecastModel?.list?.count else { return 0 }
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell()
        }
        
        if let listItem = forecastModel?.list?[indexPath.item] {
            cell.configureCell(listItem)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableHeaderView.reuseIdentifier, for: indexPath) as? CollectionReusableHeaderView else { return CollectionReusableHeaderView() }
        
        if let weatherModel = weatherModel, let placemark = currentPlacemark {
            header.configureHeaderCell(item: weatherModel, placemark: placemark)
        }
        
        return header
    }
}

// MARK: UICollectionViewDelegateFlowLayout Confirmation
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: self.view.bounds.height / Constants.collectionReusableHeaderViewHeightRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: self.view.bounds.height / Constants.collectionViewCellHeightRatio)
    }
}

// MARK: Autolayout Methods
extension ViewController {
    private func setUpLayout() {
        self.view.addSubview(backgroundImageView)
        self.view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.collectionViewDefaultPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.collectionViewDefaultPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.collectionViewDefaultPadding),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.collectionViewDefaultPadding),
        ])
    }
}

// MARK: DataServiceDelegate Conformation
extension ViewController: WeatherForecastDataServiceDelegate {
    func notifyWeatherModelDidUpdate(dataService: DataDownloadable, model: WeatherModel?) {
        weatherModel = model
        collectionView.reloadData()
    }
    
    func notifyForecastModelDidUpdate(dataService: DataDownloadable, model: ForecastModel?) {
        forecastModel = model
        collectionView.reloadData()
    }
}

// MARK: LocationManagerDelegate Conformation
extension ViewController: LocationManagerDelegate {
    func didUpdatePlacemark(locationManager: LocationManager, placemark: CLPlacemark) {
        currentPlacemark = placemark
        collectionView.reloadData()
    }
    
    func didUpdateLocation(locationManager: LocationManager, location: CLLocation) {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else { return }
        DispatchQueue.global().async { [weak self] in
            locationManager.reverseGeocodeLocation(location: location)
            self?.weatherDataService.downloadData(serviceType: .weather(coordinate: location.coordinate, apiKey: apiKey))
            self?.forecastDataService.downloadData(serviceType: .forecast(coordinate: location.coordinate, apiKey: apiKey))
        }
    }
}
