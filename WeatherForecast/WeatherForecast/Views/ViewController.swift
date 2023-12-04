//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    lazy var country: String = ""
    var subscriber: AnyCancellable?
    let locationManager = WeatherLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        setUpLayouts()
        setUpConstraints()
        
        collectionView.dataSource = self
        collectionView.delegate = self

    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .darkGray
        collectionView.register(WeatherHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private func setUpLayouts() {
        view.backgroundColor = .systemPink
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    // MARK: - 몸통
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    // MARK: - 머리	
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
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
                    self?.countryLabel.text = error.localizedDescription
                }
            } receiveValue: { [self] weather in
                country = weather.system.country
            }
    }
    
    func updateAddress(_ addressString: String) {
//                addressLabel.text = addressString
    }
}
