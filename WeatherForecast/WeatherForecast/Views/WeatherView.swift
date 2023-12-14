//
//  CustomView.swift
//  WeatherForecast
//
//  Created by 김진웅 on 12/1/23.
//

import UIKit
protocol UIUpdatable: AnyObject {
    
    func fetchAddress() -> String?
    func fetchCurrentWeather() -> Current?
    func fetchForecastWeather() -> Forecast?
    func fetchIcon(with iconID: String, completion: @escaping (UIImage?) -> Void)
}

final class WeatherView: UIView {
    enum Section {
        case main
    }
    
    private weak var delegate: UIUpdatable?
    private var dataSource: UICollectionViewDiffableDataSource<Section, List>?
    
    // MARK: - UI Components

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "wallpaper")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        return imageView
    }()
    
    private lazy var weatherCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCompositionalLayout())
        collectionView.backgroundColor = .clear
        
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
    
    // MARK: - Initializer

    init(delegate: UIUpdatable) {
        self.delegate = delegate
        super.init(frame: .zero)
        self.setConstraints()
        self.configureWeatherCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints

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
    
    // MARK: - Configure Method

    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .clear
        let compositionalLayout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return compositionalLayout
    }
    
    private func configureWeatherCollectionView() {
        configureCell()
        configureHeaderView()
    }
    
    private func configureCell() {
        dataSource = UICollectionViewDiffableDataSource<Section, List>(collectionView: weatherCollectionView) { [weak self]
            collectionView, indexPath, item in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseIdentifier,
                                                                for: indexPath) as? ForecastCell
            else {
                return ForecastCell()
            }
            
            guard let forecastModel = self?.delegate?.fetchForecastWeather()
            else {
                return ForecastCell()
            }
            
            let weatherData = forecastModel.list[indexPath.row]
            guard let iconID = weatherData.weather.last?.icon
            else {
                return ForecastCell()
            }
            
            self?.delegate?.fetchIcon(with: iconID) { icon in
                cell.configureUI(with: weatherData, icon: icon)
            }
            return cell
        }
    }
    
    private func configureHeaderView() {
        guard let dataSource = dataSource
        else {
            return
        }
        
        dataSource.supplementaryViewProvider = { [weak self]
            collectionView, kind, indexPath in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                   withReuseIdentifier: WeatherHeaderView.reuseIdentifier,
                                                                                   for: indexPath) as? WeatherHeaderView
            else {
                return WeatherHeaderView()
            }
            
            let address = self?.delegate?.fetchAddress()
            guard let weatherData = self?.delegate?.fetchCurrentWeather(),
                  let iconID = weatherData.weather.last?.icon
            else {
                return WeatherHeaderView()
            }
            
            self?.delegate?.fetchIcon(with: iconID) { icon in
                headerView.configureUI(with: address, weather: weatherData, icon: icon)
            }
            return headerView
        }
    }
    
    // MARK: - Public Method

    func reload(with forecast: Forecast?) {
        guard let forecast = forecast,
              let dataSource = dataSource
        else {
            return
        }

        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(forecast.list, toSection: .main)
        snapshot.reloadSections([.main])
        
        dataSource.apply(snapshot, animatingDifferences: true)
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
