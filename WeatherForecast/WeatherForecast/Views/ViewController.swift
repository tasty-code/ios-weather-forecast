//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

class ViewController: UIViewController {
    
    lazy var address: String = ""
    lazy var currentTempMin: String = ""
    lazy var currentTempMax: String = ""
    lazy var currentTemp: String = ""
    lazy var currentIcon: String = ""
    
    
    var subscriber: AnyCancellable?
    let locationManager = WeatherLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        setUpLayouts()
        setUpConstraints()
        
        collectionView.dataSource = self
        
    }
    
    private let compositionaLayout: UICollectionViewCompositionalLayout = {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15))
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 3, bottom: 5, trailing: 3)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = compositionaLayout
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkGray
        collectionView.register(WeatherHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
    
    func configureURLRequest(_ coordinate: CLLocationCoordinate2D) -> URLRequest? {
        guard let url = WeatherURLManager().getURL(api: .weather, latitude: coordinate.latitude, longitude: coordinate.longitude) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    // MARK: - 머리
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? WeatherHeaderCollectionViewCell else {
                return WeatherHeaderCollectionViewCell()
            }
            
            header.addressLabel.text = address
            header.minMaxTemperatureLabel.text = "최저 \(currentTempMin)° 최고 \(currentTempMax)°"
            header.temperatureLabel.text = currentTemp + "°"
            return header
        }
        return UICollectionReusableView()
    }
    // MARK: - 몸통
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? WeatherCollectionViewCell else {
            return WeatherCollectionViewCell()
        }
        
        return cell
    }
}

extension ViewController: WeatherUIDelegate {
    func loadForecast(_ coordinate: CLLocationCoordinate2D) {
        guard let urlRequest = configureURLRequest(coordinate) else {
            return
        }
        
        let publisher = URLSession.shared.publisher(request: urlRequest)
        subscriber =  WeatherHTTPClient.publishForecast(from: publisher, forecastType: CurrentWeather.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [self] weather in
                currentTempMin = String(weather.mainInfo.temperatureMin)
                currentTempMax = String(weather.mainInfo.temperatureMax)
                currentTemp = String(weather.mainInfo.temperature)
                currentIcon = "https://openweathermap.org/img/wn/" + weather.weathers[0].icon + ".png"
                print(currentIcon)
                
            }
    }
    
    func updateAddress(_ addressString: String) {
        address = addressString
    }
}
