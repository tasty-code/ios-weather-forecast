//
//  CustomView.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/1/23.
//

import UIKit

final class WeatherView: UIView {
    
    var headerView: WeatherHeaderView? {
        let indexPaths = weatherCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        
        guard let firstIndexPath = indexPaths.first,
              let headerView = weatherCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: firstIndexPath) as? WeatherHeaderView
        else {
            return nil
        }
        return headerView
    }
    
    private weak var delegate: UICollectionViewDataSource?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wallpaper")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        return imageView
    }()
    
    private lazy var weatherCollectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .clear
        let compositionalLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.dataSource = delegate
        
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseIdentifier)
        collectionView.register(WeatherHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: WeatherHeaderView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .white
        
        addSubview(collectionView)
        
        return collectionView
    }()
    
    init(delegate: UICollectionViewDataSource) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        let safeArea = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            weatherCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            weatherCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            weatherCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            weatherCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)
        ])
    }
    
    func updateCollectionView() {
        let indexPaths = weatherCollectionView.indexPathsForVisibleItems
        
        if indexPaths.isEmpty {
            weatherCollectionView.reloadData()
        } else {
            weatherCollectionView.reloadItems(at: indexPaths)
        }
    }
    
    func endRefreshing() {
        if weatherCollectionView.refreshControl?.isRefreshing == true {
            weatherCollectionView.refreshControl?.endRefreshing()
        }
    }
    
    func addRefreshControl(refreshControl: UIRefreshControl) {
        weatherCollectionView.refreshControl = refreshControl
    }
}
