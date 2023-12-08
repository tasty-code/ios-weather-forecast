//
//  MainWeatherView.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/12/08.
//

import UIKit

final class MainWeatherView: UIView {
    
    private weak var delegate: (UICollectionViewDataSource & UICollectionViewDelegateFlowLayout)?
    
    init(delegate: (UICollectionViewDataSource & UICollectionViewDelegateFlowLayout)?) {
        self.delegate = delegate
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
        collectionView.dataSource = delegate
        collectionView.delegate = delegate
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
    
    func updateUI() {
        collectionView.reloadData()
    }
}
