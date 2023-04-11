//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    //MARK: - Private Property

    private let useCase = UseCase()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: configureCollectionView())

        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(CurrentWeatherHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentWeatherHeaderView.identifier)
        collectionView.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.identifier)
        collectionView.refreshControl = refresh
        collectionView.layer.cornerRadius = 20.0

        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        return collectionView
    }()
    private lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WeatherBackground")
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var refresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()

        refreshControl.addTarget(self, action: #selector(handleRefreshControl) , for: .valueChanged)

        return refreshControl
    }()
    
    private var currentWeather: CurrentViewModel?
    private var forecastWeathers: [ForecastViewModel]?
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)

        useCase.delegate = self
        collectionView.dataSource = self
        UserLocation.shared.delegate = self
        UserLocation.shared.authorize()
        useCase.loadIconImage()
    }
    
    //MARK: - Objective-C Method

    @objc func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.changedAuthorization()
            self.refresh.endRefreshing()
        }
    }
}

//MARK: - Configure CollectionView Layout
extension WeatherViewController {
    private func configureCollectionView() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        configuration.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.2)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

//MARK: - Configure CollectionView DataSource
extension WeatherViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        forecastWeathers?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastWeatherCell.identifier, for: indexPath) as? ForecastWeatherCell else {
            return UICollectionViewCell()
        }
        
        if let certifiedModel = forecastWeathers?[indexPath.row] {
            cell.prepare(model: certifiedModel)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CurrentWeatherHeaderView.identifier, for: indexPath) as? CurrentWeatherHeaderView else {
                return UICollectionReusableView()
            }
            
            if let certifiedModel = currentWeather {
                headerView.prepare(model: certifiedModel)
            }
            
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
}

//MARK: - Delegate Method
extension WeatherViewController: WeatherModelDelegate {
    func loadCurrentWeather(of model: CurrentViewModel) {
        currentWeather = model
        self.collectionView.reloadData()
    }

    func loadForecastWeather(of model: [ForecastViewModel]) {
        forecastWeathers = model
        self.collectionView.reloadData()
    }
}

extension WeatherViewController: UserLocationDelegate {
    func changedAuthorization() {
        let location = useCase.receiveCurrentLocation()
        useCase.determine(with: location)
    }
}
