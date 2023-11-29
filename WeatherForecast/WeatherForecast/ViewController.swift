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
        static let collectionReusableHeaderViewHeightRatio: CGFloat = 6
        static let collectionViewDefaultPadding: CGFloat = 10
    }
    
    //MARK: - View Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemPink
        return collectionView
    }()
    
    private lazy var dataService: WeatherForecastDataServiceProtocol = WeatherForecastDataService(dataServiceDelegate: self)
    private let locationManager: LocationManager = LocationManager()
    
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableHeaderView.reuseIdentifier, for: indexPath) as? CollectionReusableHeaderView else { return CollectionReusableHeaderView() }
        
        return header
    }
}

// MARK: UICollectionViewDelegateFlowLayout Confirmation
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: self.view.bounds.height / Constants.collectionReusableHeaderViewHeightRatio)
    }
}

// MARK: Autolayout Methods
extension ViewController {
    private func setUpLayout() {
        self.view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.collectionViewDefaultPadding),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: Constants.collectionViewDefaultPadding),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.collectionViewDefaultPadding),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.collectionViewDefaultPadding),
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
        dataService.reverseGeocodeLocation(location: location)
    }
}
