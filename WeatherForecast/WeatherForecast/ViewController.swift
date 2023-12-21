//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class ViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let collectionReusableHeaderViewHeightRatio: CGFloat = 8
        static let collectionViewCellHeightRatio: CGFloat = 20
        static let collectionViewDefaultPadding: CGFloat = 14
        static let locationChangeAlertTitle: String = "위치변경"
        static let locationChangeAlertSubscript: String = "날씨를 받아올 위치의 위도와 경도를 입력해주세요."
        static let locationChangeAlertConfirmButtonName: String = "변경"
        static let locationChangeAlertCancelButtonName: String = "취소"
        static let latitudeTextFieldPlaceholder: String = "위도"
        static let longitudeTextFieldPlaceholder: String = "갱도"
    }
    
    // MARK: - View Components
    private lazy var backgroundImageView: UIImageView = {
        let image = UIImage(named: "RootViewBackground")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.tintColor = .white
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        return collectionView
    }()
    
    private lazy var navigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("그래프 띄우기", for: .normal)
        button.addTarget(self, action: #selector(pushGraphView), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Dependencies
    private lazy var weatherDataService: DataDownloadable = WeatherDataService(dataServiceDelegate: self)
    private lazy var forecastDataService: DataDownloadable = ForecastDataService(dataServiceDelegate: self)
    private let locationManager: LocationManager
    
    // MARK: - Properties
    private var weatherModel: WeatherModel? = nil
    private var forecastModel: ForecastModel? = nil
    private var currentPlacemark: CLPlacemark? = nil
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Failed to initialize ViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        collectionView.register(CollectionReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionReusableHeaderView.reuseIdentifier)
        setUpLayout()
        setUpConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        
//        coordinator.animate { [weak self] _ in
//            guard let self = self else { return }
//            
//            if size.width > size.height {
//                guard let lists = forecastModel?.list else { return }
//                collectionView.isHidden = true
//                graphView.lists = lists
//                graphView.isHidden = false
//            } else {
//                collectionView.isHidden = false
//                graphView.isHidden = true
//            }
//        }
    }
}

// MARK: Private Methods
extension ViewController {
    @objc private func refreshCollectionView(_ location: CLLocation) {
        collectionView.refreshControl?.beginRefreshing()
        locationManager.requestLocation()
    }
    
    @objc private func presentLocationChangeAlert() {
        let alert = UIAlertController(title: Constants.locationChangeAlertTitle , message: Constants.locationChangeAlertSubscript, preferredStyle: .alert)
        let changeAction = UIAlertAction(title: Constants.locationChangeAlertConfirmButtonName, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            guard let latitudeText = alert.textFields?.first?.text,
                  let longitudeText = alert.textFields?.last?.text,
                  let latitude: CLLocationDegrees = Double(latitudeText),
                  let longitude: CLLocationDegrees = Double(longitudeText)
            else {
                return
            }
            
            let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            didUpdateLocation(locationManager: locationManager, location: location)
        }
        let cancelAction = UIAlertAction(title: Constants.locationChangeAlertCancelButtonName, style: .cancel)
        
        alert.addAction(changeAction)
        alert.addAction(cancelAction)
        alert.addTextField { latitudeField in
            latitudeField.placeholder = Constants.latitudeTextFieldPlaceholder
            latitudeField.keyboardType = .decimalPad
            latitudeField.clearButtonMode = .whileEditing
        }
        alert.addTextField { longitudeField in
            longitudeField.placeholder = Constants.longitudeTextFieldPlaceholder
            longitudeField.keyboardType = .decimalPad
            longitudeField.clearButtonMode = .whileEditing
        }
        
        present(alert, animated: true)
    }
    
    @objc private func pushGraphView() {
        let graphViewController = GraphViewController()
        graphViewController.lists = forecastModel?.list
        self.navigationController?.pushViewController(graphViewController, animated: true)
    }
}

// MARK: UICollectionViewDelegate, DataSource Confirmation
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionCount = forecastModel?.list?.count else { return 0 }
        return sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell()
        }
        
        if let listItem = forecastModel?.list?[indexPath.item] {
            cell.configureCell(listItem)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionReusableHeaderView.reuseIdentifier, for: indexPath) as? CollectionReusableHeaderView else { return CollectionReusableHeaderView() }
        
        if let weatherModel = weatherModel, let placemark = currentPlacemark {
            header.configureHeaderCell(item: weatherModel, placemark: placemark)
        }
        
        header.delegate = self
        
        return header
    }
}

// MARK: UICollectionViewDelegateFlowLayout Confirmation
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: self.view.bounds.height / Constants.collectionReusableHeaderViewHeightRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: self.view.bounds.height / Constants.collectionViewCellHeightRatio)
    }
}

// MARK: Autolayout Methods
extension ViewController {
    private func setUpLayout() {
        self.view.addSubviews([backgroundImageView, collectionView, navigationButton])
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.collectionViewDefaultPadding),
            collectionView.bottomAnchor.constraint(equalTo: navigationButton.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.collectionViewDefaultPadding),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.collectionViewDefaultPadding),
        ])
        
        NSLayoutConstraint.activate([
            navigationButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            navigationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.collectionViewDefaultPadding),
        ])
    }
}

// MARK: DataServiceDelegate Conformation
extension ViewController: WeatherForecastDataServiceDelegate {
    func notifyWeatherModelDidUpdate(dataService: DataDownloadable, model: WeatherModel?) {
        weatherModel = model
        let headerViewIndexPaths = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        
        if headerViewIndexPaths.isEmpty {
            collectionView.reloadData()
        } else {
            collectionView.reloadItems(at: headerViewIndexPaths)
        }
        
        if collectionView.refreshControl?.isRefreshing == true {
            collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func notifyForecastModelDidUpdate(dataService: DataDownloadable, model: ForecastModel?) {
        forecastModel = model
        let cellIndexPaths = collectionView.indexPathsForVisibleItems
        
        if cellIndexPaths.isEmpty {
            collectionView.reloadData()
        } else {
            collectionView.reloadItems(at: cellIndexPaths)
        }
        
        if collectionView.refreshControl?.isRefreshing == true {
            collectionView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: LocationManagerDelegate Conformation
extension ViewController: LocationManagerDelegate {
    func didUpdatePlacemark(locationManager: LocationManager, placemark: CLPlacemark) {
        currentPlacemark = placemark
        collectionView.reloadData()
    }
    
    func didUpdateLocation(locationManager: LocationManager, location: CLLocation) {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            locationManager.reverseGeocodeLocation(location: location)
            self?.weatherDataService.downloadData(serviceType: .weather(coordinate: location.coordinate, apiKey: apiKey))
            self?.forecastDataService.downloadData(serviceType: .forecast(coordinate: location.coordinate, apiKey: apiKey))
        }
    }
}

// MARK: AlertPresentingDelegate Confirmation
extension ViewController: AlertPresentingDelegate {
    func presentAlert(collectionViewHeader: UICollectionReusableView) {
        presentLocationChangeAlert()
    }
}
