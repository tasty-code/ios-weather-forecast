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
        }
    }

    private var forecastDatas: [ForecastData] = [] {
        didSet {
            updateListView()
        }
    }

    // MARK: - UI Components

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewBackground()
        setupLocationDataManager()
        setupCollectionView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
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
        repository.fetchWeather(coordinate: coordinate) { [weak self] result in
            switch result {
            case .success(let currentWeather):
                self?.currentWeather = currentWeather
            case .failure(let error):
                log(.network, error: error)
            }
        }
    }

    private func fetchForecast(coordinate: Coordinate) {
        repository.fetchForecast(coordinate: coordinate) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.forecastDatas = forecast.forecastDatas
            case .failure(let error):
                log(.network, error: error)
            }
        }
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
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
    }

    private func setupViewBackground() {
        let backgroundIamgeView = UIImageView(frame: view.frame)
        backgroundIamgeView.image = UIImage(named: Constants.backgroundImageFileName)
        backgroundIamgeView.contentMode = .scaleAspectFill

        view.addSubview(backgroundIamgeView)
        view.sendSubviewToBack(backgroundIamgeView)
    }

    private func updateHeaderView() {
        guard let currentWeather,
              let placemark = addressManager.placemark else { return }

        repository.fetchWeatherIconImage(withID: currentWeather.weathers.first?.icon ?? "") { result in
            switch result {
            case.success(let image):
                DispatchQueue.main.async {
                    guard let headerView = self.collectionView.visibleSupplementaryViews(
                        ofKind: UICollectionView.elementKindSectionHeader
                    ).first as? WeatherHeaderView else { return }
                    headerView.configure(
                        with: currentWeather.weatherDetail,
                        address: "\(placemark.locality ?? "") \(placemark.name ?? "")",
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
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        let height = view.frame.height / 7
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return forecastDatas.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeatherCell.identifier,
            for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }

        guard let weather = forecastDatas[safe: indexPath.row] else { return cell }
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

// MARK: - UICollectionViewDelegateFlowLayout

extension WeatherListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = view.frame.height / 15
        return CGSize(width: width, height: height)
    }

}
