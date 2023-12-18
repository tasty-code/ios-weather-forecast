//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    private let locationDataManager = LocationDataManager()
    private let dataManager = WeatherDataManager()
    
    private var backgroundImageView: UIImageView!
    private var collectionView: UICollectionView!
    
    typealias WeatherDataSource = UICollectionViewDiffableDataSource<Section, WeatherForecast.WeatherList>
    
    var dataSource: WeatherDataSource? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        configureHierarchy()
        configureDataSource()
        setRefreshControl()
        
        locationDataManager.locationDelegate = self
        dataManager.delegate = self
        collectionView.delegate = self
    }
    
    private func configureHierarchy() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        // autoresizingMask: bounds로 적용했을 때, subview의 크기를 어떻게 변경할 것인가에 대한.
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = UIColor(white: 1, alpha: 0.2)
        
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing = CGFloat(10)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<WeatherCollectionViewCell, WeatherForecast.WeatherList> { (cell, indexPath, item) in
            self.bind(on: cell, indexPath: indexPath)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <WeatherCollectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (headerView, string, indexPath) in
            self.bind(on: headerView)
        }
        
        dataSource = WeatherDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: WeatherForecast.WeatherList) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        dataSource?.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
}

// MARK: - Bind view

extension WeatherViewController {
    private func bind(on header: WeatherCollectionHeaderView) {
        header.addressLabel.text = dataManager.address
        if let today = dataManager.today {
            let temperature = today.main.temp.formatCelsius()
            let temperatureMin = today.main.tempMin.formatCelsius()
            let temperatureMax = today.main.tempMax.formatCelsius()
            let code = today.weather[0].icon
            
            header.currentTemperatureLabel.text = temperature
            header.maxAndMinTemperatureLabel.text = "최저 \(temperatureMin) 최고 \(temperatureMax)"
            bindImage(imageView: header.headerIconImageView, code: code)
        }
    }
    
    private func bind(on cell: WeatherCollectionViewCell, indexPath: IndexPath) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd(E) HH시"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        if let forecast = dataManager.forecast {
            let timeInterval = forecast.list[indexPath.row].dt
            let date = NSDate(timeIntervalSince1970: TimeInterval(timeInterval))
            let temperature = forecast.list[indexPath.row].main.temp.formatCelsius()
            let code = forecast.list[indexPath.row].weather[0].icon
            
            cell.dateLabel.text = dateFormatter.string(from: date as Date)
            cell.temperatureLabel.text = temperature
            bindImage(imageView: cell.cellIconImageView, code: code)
        }
    }
    
    private func bindImage(imageView: UIImageView, code: String) {
        if let image = ImageCacheManager.getCache(forKey: code) {
            imageView.image = image
        } else {
            guard let image = ImageFileManager.getImage(forKey: code) else {
                print("fileManager에 해당 image 없음")
                return
            }
            ImageCacheManager.setCache(image: image, forKey: code)
            imageView.image = image
        }
    }
}



// MARK: - UICollectionViewDelegate

extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Set ViewController UI

extension WeatherViewController {
    private func setUI() {
        backgroundImageView  = {
            let imageView = UIImageView(frame: .zero)
            imageView.image = UIImage(named: "isaiah")
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        view.addSubview(backgroundImageView)
        setConstraint()
    }
    
    private func setConstraint() {
        NSLayoutConstraint.activate([
            // imageView
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - LocationDataManagerDelegate

extension WeatherViewController: LocationDataManagerDelegate {
    
    func location(_ manager: LocationDataManager, didLoadCoordinate coordinate: CLLocationCoordinate2D) {
        dataManager.downloadData(with: coordinate)
    }
    
    func loaction(_ manager: LocationDataManager, didCompletePlacemark placemark: CLPlacemark?) {
        guard let placemark else {
            print("can't look up current address")
            return
        }
        
        dataManager.address = "\(placemark.locality ?? "") \(placemark.subLocality ?? "")"
    }
    
    func viewRequestLocationSettingAlert() {
        let requestLocationServiceAlert = UIAlertController(
            title: "위치 정보 이용",
            message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.",
            preferredStyle: .alert
        )
        let openSettingAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let exitAction = UIAlertAction(title: "종료", style: .destructive) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        requestLocationServiceAlert.addAction(openSettingAction)
        requestLocationServiceAlert.addAction(exitAction)
        present(requestLocationServiceAlert, animated: true)
    }
}

// MARK: - WeatherDataManagerDelegate

extension WeatherViewController: WeatherDataManagerDelegate {
    func updateTodayWeatherView(_ manager: WeatherDataManager, with today: WeatherToday) {
        updateView()
    }
    
    func updateForecastWeatherView(_ manager: WeatherDataManager, with forecast: WeatherForecast) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WeatherForecast.WeatherList>()
        snapshot.appendSections([.main])
        snapshot.appendItems(forecast.list)
        self.dataSource?.apply(snapshot)
        
        updateView()
    }
    
    private func updateView() {
        DispatchQueue.main.async { [self] in
            collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Set refreshControl

extension WeatherViewController {
    private func setRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc
    private func handleRefreshControl() {
        locationDataManager.startUpdatingLocation()
    }
}
