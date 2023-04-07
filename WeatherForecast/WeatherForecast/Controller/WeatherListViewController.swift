//
//  WeatherListViewController - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherListViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let backgroundImageFileName = "WeatherBackgroundImage"
    }
    
    // MARK: - Properties
    
    private let repository = OpenWeatherRepository(
        deserializer: JSONDesirializer(),
        service: NetworkService()
    )

    private let locationDataManager = LocationDataManager()
    private let addressManager = AddressManager()

    private var currentWeather: CurrentWeather? = nil {
        didSet {
            updateHeaderView()
            //            endRefreshing()
        }
    }

    private var forecastDatas: [ForecastData] = [] {
        didSet {
            updateListView()
            //            endRefreshing()
        }
    }

    private let endRefreshingDispatchGroup = DispatchGroup()

    // MARK: - UI Components

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createCollectionViewLayout()
    )

    private let refreshControl = UIRefreshControl()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationDataManager()
        setupCollectionView()
        setupViewBackground()
        setupLayout()
    }

    // MARK: - Private

    private func setupLocationDataManager() {
        locationDataManager.delegate = self

        if !locationDataManager.isAuthorized {
            locationDataManager.requestAuthorization()
        }
    }

    private func fetchLocation() {
        locationDataManager.requestLocation()
    }

    private func fetchWeather(coordinate: Coordinate) {
        endRefreshingDispatchGroup.enter()
        repository.fetchWeather(coordinate: coordinate) { [weak self] result in
            guard let self else { return }
            print("fetchWeather 끝남")
            switch result {
            case .success(let currentWeather):
                self.currentWeather = currentWeather
            case .failure(let error):
                log(.network, error: error)
            }
            self.endRefreshingDispatchGroup.leave()
        }
    }

    private func fetchForecast(coordinate: Coordinate) {
        endRefreshingDispatchGroup.enter()
        repository.fetchForecast(coordinate: coordinate) { [weak self] result in
            guard let self else { return }
            print("fetchForecast 끝남")
            switch result {
            case .success(let forecast):
                self.forecastDatas = forecast.forecastDatas
            case .failure(let error):
                log(.network, error: error)
            }
            self.endRefreshingDispatchGroup.leave()
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(
            WeatherCell.self,
            forCellWithReuseIdentifier: WeatherCell.identifier
        )
        collectionView.register(
            WeatherHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: WeatherHeaderView.identifier
        )

        setupRefreshControl()
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func pullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchLocation()
    }

    private func endRefreshing() {
        guard refreshControl.isRefreshing else { return }

        self.refreshControl.endRefreshing()
    }

    private func setNotifyEndRefreshingToDispatchGroup() {
        endRefreshingDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            print("DispatchGroup notify : 끝남")
            self?.endRefreshing()
        }
    }
    
    // MARK: - Layout

    private func setupViewBackground() {
        let backgroundIamgeView = UIImageView(frame: view.frame)
        backgroundIamgeView.image = UIImage(named: Constants.backgroundImageFileName)
        backgroundIamgeView.contentMode = .scaleAspectFill

        view.addSubview(backgroundIamgeView)
        view.sendSubviewToBack(backgroundIamgeView)
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        configuration.backgroundColor = .clear
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }

    private func updateHeaderView() {
        guard let currentWeather else { return }

        repository.fetchWeatherIconImage(withID: currentWeather.weathers.first?.icon ?? "") { result in
            switch result {
            case.success(let image):
                DispatchQueue.main.async {
                    guard let headerView = self.collectionView.visibleSupplementaryViews(
                        ofKind: UICollectionView.elementKindSectionHeader
                    ).first as? WeatherHeaderView else { return }

                    headerView.configure(
                        with: currentWeather.weatherDetail,
                        address: self.addressManager.address,
                        icon: image
                    )
                }
            case.failure(let error):
                log(.network, error: error)
            }
        }
    }

    private func updateListView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

// MARK: - LocationDataManagerDelegate

extension WeatherListViewController: LocationDataManagerDelegate {

    func locationDataManager(_ locationDataManager: LocationDataManager,
                             didAuthorized isAuthorized: Bool) {
        guard isAuthorized else { return }
        fetchLocation()
    }

    func locationDataManager(_ locationDataManager: LocationDataManager,
                             didUpdateLocation location: CLLocation) {
        addressManager.fetchAddress(of: location)

        guard let coordinate = locationDataManager.currentCoordinate else { return }

        fetchWeather(coordinate: coordinate)
        fetchForecast(coordinate: coordinate)
        setNotifyEndRefreshingToDispatchGroup()
    }
    
}

// MARK: - UICollectionViewDataSource

extension WeatherListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: WeatherHeaderView.identifier,
            for: indexPath) as? WeatherHeaderView else {
            return UICollectionReusableView()
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return forecastDatas.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeatherCell.identifier,
            for: indexPath) as? WeatherCell,
              let weather = forecastDatas[safe: indexPath.row] else {
            return UICollectionViewCell()
        }

        let date = DateFormatUtil.format(with: weather.dateString)
        let temperature = String(weather.weatherDetail.temperature)
        let iconID = weather.weathers.first?.icon ?? ""

        repository.fetchWeatherIconImage(withID: iconID) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.configure(icon: image)
                }
            case .failure(let error):
                log(.network, error: error)
            }
        }

        cell.configure(date: date, temperature: temperature)
        return cell
    }

}
