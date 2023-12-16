//
//  MainWeatherView.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/12/08.
//

import UIKit

final class MainWeatherView: UIView {
    private weak var weatherDataDelegate: WeatherDataDelegate?
    private weak var imageDelegate: ImageUpdatable?
    private weak var locationDelegate: LocationRequestDelegate?
    
    init(weatherDataDelegate: WeatherDataDelegate?, imageDelegate: ImageUpdatable?, locationDelegate: LocationRequestDelegate?) {
        self.weatherDataDelegate = weatherDataDelegate
        self.imageDelegate = imageDelegate
        self.locationDelegate = locationDelegate
        super.init(frame: .zero)
        collectionViewConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionViewConfigure()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            configuration.headerMode = .supplementary

            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            let section = NSCollectionLayoutSection.list(using: configuration,
                                                         layoutEnvironment: layoutEnvironment)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(WeeklyWeatherCell.self, forCellWithReuseIdentifier: WeeklyWeatherCell.reuseIdentifier)
        collectionView.register(CurrentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentHeaderView.reuseIdentifier)
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
        return collectionView
    }()
    
    private func collectionViewConfigure() {
        addSubview(collectionView)
        
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    @objc private func handleRefreshControl() {
        locationDelegate?.updateLocation()
    }
}

extension MainWeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let cellCount = weatherDataDelegate?.getCellCount() else {
            return 0
        }
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeeklyWeatherCell.reuseIdentifier, for: indexPath) as? WeeklyWeatherCell else {
            return WeeklyWeatherCell()
        }
        guard let date = weatherDataDelegate?.getDataTime(indexPath.row),
              let temperature = weatherDataDelegate?.getTemperature(indexPath.row)
        else {
            return WeeklyWeatherCell()
        }
        guard let icon = weatherDataDelegate?.getWeeklyIconName(indexPath.row) else { return WeeklyWeatherCell() }
        
        imageDelegate?.requestImage(name: icon) { image in
            cell.updateUI(date: date, temperature: temperature, image: image)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CurrentHeaderView.reuseIdentifier, for: indexPath) as? CurrentHeaderView else {
            return CurrentHeaderView()
        }
        
        guard let address = weatherDataDelegate?.getAddress(),
              let weatherData = weatherDataDelegate?.getCurrentWeatherData(),
              let icon = weatherDataDelegate?.geticonName()
        else {
            return headerView
        }
        
        imageDelegate?.requestImage(name: icon) { [weak self] image in
            headerView.updateUI(address: address, weather: weatherData, image: image)
            self?.collectionView.refreshControl?.endRefreshing()
        }
        
        return headerView
    }
}

extension MainWeatherView: UIUpdatable {
    func updateUI() {
        collectionView.reloadData()
    }
}
