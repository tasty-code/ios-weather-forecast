//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let repository = Repository()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewLayout())

        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(CurrentWeatherHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CurrentWeatherHeaderView.identifier)
        collectionView.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.identifier)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserLocation.shared.authorize()
    }
    
    @IBAction func printWeatherInformation(_ sender: UIButton) {
        UserLocation.shared.address { (address, error) in
            if let error {
                print(error)
                return
            }

            if let address {
                print(address)
            }
        }
        
        guard let location = UserLocation.shared.location?.coordinate else {
            return
        }
        
        URLPath.allCases.forEach { weatherType in
            repository.loadData(with: location, path: weatherType) { data, error in
                if let error {
                    print(error)
                    return
                }

                if let data {
                    print(data)
                }
            }
        }
    }
}
