//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
//    private let repository = Repository()
    private let useCase = UseCase()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureCollectionView())
        
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(CurrentWeatherHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentWeatherHeaderView.identifier)
        collectionView.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        collectionView.backgroundColor = .red
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    private var currentWeather: CurrentViewModel?
    private var forecastWeather: ForecastViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        useCase.delegate = self
        collectionView.dataSource = self
        UserLocation.shared.authorize()
        
        let location = useCase.receiveCurrentLocation()
        useCase.determine(with: location)
    }
}

extension ViewController {
    private func configureCollectionView() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.headerMode = .supplementary
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastWeatherCell.identifier, for: indexPath) as? ForecastWeatherCell else {
            return UICollectionViewCell()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CurrentWeatherHeaderView.identifier, for: indexPath) as? CurrentWeatherHeaderView else {
                return UICollectionReusableView()
            }
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

extension ViewController: WeatherModelDelegate {
    func loadCurrentWeather(of model: CurrentViewModel) {
        currentWeather = model
        self.collectionView.reloadData()
    }

    func loadForecastWeather(of model: ForecastViewModel) {
        forecastWeather = model
        self.collectionView.reloadData()
    }
}
