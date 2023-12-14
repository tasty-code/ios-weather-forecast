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
    
    init(weatherDataDelegate: WeatherDataDelegate?, imageDelegate: ImageUpdatable?) {
        self.weatherDataDelegate = weatherDataDelegate
        self.imageDelegate = imageDelegate
        super.init(frame: .zero)
        collectionViewConfigure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionViewConfigure()
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WeeklyWeatherCell.self, forCellWithReuseIdentifier: WeeklyWeatherCell.reuseIdentifier)
        collectionView.register(CurrentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentHeaderView.reuseIdentifier)
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
        
        imageDelegate?.requestImage(name: icon) { image in
            headerView.updateUI(address: address, weather: weatherData, image: image)
        }
        
        return headerView
    }
}

extension MainWeatherView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 13)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width / 2)
    }
}

extension MainWeatherView: UIUpdatable {
    func updateUI() {
        collectionView.reloadData()
    }
}
