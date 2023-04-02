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

    private var currentWeatherDetail: WeatherDetail? = nil {
        didSet {
            updateHeaderView()
        }
    }

    private var weatherForecast: [ForecastData]? = nil {
        didSet {
            updateForecastView()
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
                self?.currentWeatherDetail = currentWeather.weatherDetail
                print(currentWeather.weathers.first?.description ?? "")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fetchForecast(coordinate: Coordinate) {
        repository.fetchForecast(coordinate: coordinate) { [weak self] result in
            switch result {
            case .success(let forecast):
                self?.weatherForecast = forecast.forecastDatas
            case .failure(let error):
                print(error.localizedDescription)
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
        guard let currentWeatherDetail,
              let placemark = addressManager.placemark else { return }

        DispatchQueue.main.async {
            guard let headerView = self.collectionView.visibleSupplementaryViews(
                ofKind: UICollectionView.elementKindSectionHeader
            ).first as? WeatherHeaderView else { return }

            headerView.configure(
                with: currentWeatherDetail,
                address: "\(placemark.locality ?? "") \(placemark.name ?? "")"
            )
        }
    }

    private func updateForecastView() {
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
        addressManager.fetchAddress(of: location) { placemark in
            guard let placemark else { return }

            print(placemark.country ?? "",
                  placemark.administrativeArea ?? "",
                  placemark.locality ?? "",
                  placemark.name ?? "")
        }

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
        return weatherForecast?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeatherCell.identifier,
            for: indexPath) as? WeatherCell else {
            return UICollectionViewCell()
        }

        guard let weatherForecast else { return cell }

        let weather = weatherForecast[indexPath.row]
        let date = DateFormatter().dateString(with: weather.dateString)
        let temperature = String(weather.weatherDetail.temperature)
        let iconCode = weather.weathers.first?.icon ?? ""

        cell.configure(date: date, temperature: temperature, iconCode: iconCode)
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
