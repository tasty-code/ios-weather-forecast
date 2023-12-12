//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

class ViewController: UIViewController {
    typealias Item = (CurrentWeatherInfo?, [Forecast])
    enum Section {
        case main
    }
    
    @Published private var weatherInfo: Item = (nil, [])
    private let locationManager = WeatherLocationManager()
    private var subscribers = Set<AnyCancellable>()
    private var weatherDataSource: UICollectionViewDiffableDataSource<Section, Forecast>!
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "background")
        return image
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = compositionaLayout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .none
        collectionView.register(WeatherHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.refreshControl = refreshWeather
        return collectionView
    }()
    
    private let compositionaLayout: UICollectionViewCompositionalLayout = {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15))
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.6))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: -10, leading: 3, bottom: -10, trailing: 3)
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.07))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private lazy var refreshWeather: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.systemPink
        refresher.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return refresher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        setUpLayouts()
        setUpConstraints()
        
        configureDatasource()
        bind()
    }
    
    @objc private func handleRefreshControl() {
        refreshWeather.beginRefreshing()
        locationManager.locationManger.requestLocation()
        refreshWeather.endRefreshing()
    }
    
    private func configureDatasource() {
        weatherDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? WeatherCollectionViewCell else {
                return WeatherCollectionViewCell()
            }
            WeatherImageCache.shared.load(from: URL(string: "https://openweathermap.org/img/wn/\(itemIdentifier.weather.first!.icon).png")!) { image in
                cell.weatherIcon.image = image
            }
            cell.configureCell(to: itemIdentifier)
            return cell
        })
    }
    
    func bind() {
        $weatherInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (current, forecast) in
                self?.weatherDataSource.supplementaryViewProvider = { collectionView , kind , indexPath in
                    guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as? WeatherHeaderCollectionViewCell else {
                        return WeatherHeaderCollectionViewCell()
                    }
                    cell.configureCell(current)
                    if let icon = current?.icon {
                        WeatherImageCache.shared.load(from: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")!, completion: { image in
                            cell.image = image
                        })
                    }
                    return cell
                }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Forecast>()
                snapshot.appendSections([.main])
                snapshot.appendItems(forecast, toSection: .main)
                snapshot.reloadSections([.main])
                self?.weatherDataSource.apply(snapshot)
            }
            .store(in: &subscribers)
    }
    
    private func setUpLayouts() {
        view.addSubview(backgroundImage)
        view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            backgroundImage.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        ])
    }
}

extension ViewController: WeatherUIDelegate {
    func updateLocationWeather(_ coordinate: CLLocationCoordinate2D, _ addressString: String) {
        let urlManager = WeatherURLManager()
        guard let weatherURLRequest = urlManager.configureURLRequest(lat: coordinate.latitude, lon: coordinate.longitude, apiType: .weather) else { return }
        let weatherInfoPublisher = WeatherHTTPClient.publishForecast(from: weatherURLRequest, forecastType: CurrentWeather?.self)
        
        guard let forecastURLRequest = urlManager.configureURLRequest(lat: coordinate.latitude, lon: coordinate.longitude, apiType: .forecast) else { return }
        let forecastInfoPublisher = WeatherHTTPClient.publishForecast(from: forecastURLRequest, forecastType: FiveDayWeatherForecast.self)
        
        Publishers.Zip(forecastInfoPublisher, weatherInfoPublisher)
            .tryMap { (forecast, current) in
                let test = CurrentWeatherInfo(address: addressString, icon: current!.weathers.first!.icon, mainInfo: current!.mainInfo)
                return Item(test, forecast.list)
            }
            .handleEvents(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint(error)
                }
            })
            .replaceError(with: (nil, []))
            .assign(to: \.weatherInfo, on: self)
            .store(in: &subscribers)
    }
}
