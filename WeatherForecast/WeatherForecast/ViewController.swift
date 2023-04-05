//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    let networkManager = NetworkManager()
    let locationManager = LocationManager()

    var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self

        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.register(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCollectionViewCell.cellIdentifier)
        configureCollectionViewRestraint()
        setUp()
    }
    
    private func setUp() {
        locationManager.startUpdatingLocation()
    }

    private func configureCollectionViewRestraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: LocationManagerDelegate {
    func locationManager(_ manager: LocationManager, didUpdateLocation location: CLLocation) {
        networkManager.updateLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        networkManager.callAPI()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.cellIdentifier, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.indexpathLabel.text = "\(indexPath.section + 1)"

        return cell
    }
}

class WeatherCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "WeatherCollectionViewCell"

    var indexpathLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(indexpathLabel)
        configureLabelConstraint()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureLabelConstraint() {
        indexpathLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indexpathLabel.topAnchor.constraint(equalTo: self.topAnchor),
            indexpathLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            indexpathLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            indexpathLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
