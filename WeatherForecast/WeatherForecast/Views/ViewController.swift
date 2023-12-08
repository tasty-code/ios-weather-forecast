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
    
    private lazy var collectionView: UICollectionView = {
        let layout = compositionaLayout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkGray
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
        refresher.tintColor = UIColor.systemCyan
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
            WeatherImageCache.shared.load(from: URL(string: "https://openweathermap.org/img/wn/\(itemIdentifier.weather.first!.icon)@2x.png")!) { image in
                cell.imageView.image = image
            }
            cell.configureCell(to: itemIdentifier)
            return cell
        })
    }
    
    func bind() {
        $weatherInfo
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] (current, forecast) in
                weatherDataSource.supplementaryViewProvider = { collectionView , kind , indexPath in
                    guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as? WeatherHeaderCollectionViewCell else {
                        return WeatherHeaderCollectionViewCell()
                    }
                    if let data = current {
                        cell.addressLabel.text = data.address
                        cell.temperatureLabel.text = String(data.temp.temperature)
                        cell.minMaxTemperatureLabel.text = "최저 \(data.temp.temperatureMin)° 최고 \(data.temp.temperatureMax)°"
                        WeatherImageCache.shared.load(from: URL(string: "https://openweathermap.org/img/wn/\(data.icon)@2x.png")!, completion: { image in
                            cell.weatherIcon.image = image
                        })
                    } else {
                        cell.temperatureLabel.text = "nan"
                    }
                    return cell
                }
                
                var snapshot = NSDiffableDataSourceSnapshot<Section, Forecast>()
                snapshot.appendSections([.main])
                snapshot.appendItems(forecast, toSection: .main)
                snapshot.reloadSections([.main])
                weatherDataSource.apply(snapshot)
            }
            .store(in: &subscribers)
    }
    
    private func setUpLayouts() {
        view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
        ])
    }
    
    func configureURLRequest(_ coordinate: CLLocationCoordinate2D, apiType: WeatherURLManager.ForecastType) -> URLRequest? {
        guard let url = WeatherURLManager().getURL(api: apiType, latitude: coordinate.latitude, longitude: coordinate.longitude) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}

extension ViewController: WeatherUIDelegate {
    func loadForecast(_ coordinate: CLLocationCoordinate2D) {
        
    }
    
    func updateAddress(_ coordinate: CLLocationCoordinate2D, _ addressString: String) {
        guard let weatherURLRequest = configureURLRequest(coordinate, apiType: .weather) else { return }
        let publisher2 = URLSession.shared.publisher(request: weatherURLRequest)
        let p2 = WeatherHTTPClient.publishForecast(from: publisher2, forecastType: CurrentWeather?.self)
        
        guard let forecastURLRequest = configureURLRequest(coordinate, apiType: .forecast) else { return }
        let publisher = URLSession.shared.publisher(request: forecastURLRequest)
        let p1 = WeatherHTTPClient.publishForecast(from: publisher, forecastType: FiveDayWeatherForecast.self)
        Publishers.Zip(p1, p2)
            .tryMap { (forecast, current) in
                let test = CurrentWeatherInfo(address: addressString, icon: current!.weathers.first!.icon, temp: current!.mainInfo)
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
    
    func fetchWeatherInfo(_ coordinate: CLLocationCoordinate2D) { }
}

extension ViewController {
    struct CurrentWeatherInfo {
        let address: String
        let icon: String
        let temp: MainInfo
    }
}
