import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private lazy var weatherCollectionView: WeatherCollectionView = WeatherCollectionView(frame: .zero, collectionViewLayout: createBasicListLayout())
    private let locationManager = CLLocationManager()
    private let networkServiceProvider = NetworkServiceProvider(session: URLSession.shared)
    private let iconCacheManager = CacheManager()
    private let jsonLoader = JsonLoader()
    
    private var forecast: ForecastWeather?
    private var current: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImageView()
        setRefreshControl()
        
        locationManagerConfiguration()
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.setCollectionViewConstraints(view: view)
    }
}

//MARK: - Configuration
extension WeatherViewController {
    private func setBackgroundImageView() {
        let backgroundImage = UIImage(named: "wallpaper")
        let backgroundImageView = UIImageView(image: backgroundImage)
        
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func locationManagerConfiguration() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func setRefreshControl() {
        weatherCollectionView.refreshControl = UIRefreshControl()
        weatherCollectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.weatherCollectionView.reloadData()
            self.weatherCollectionView.refreshControl?.endRefreshing()
        }
    }
}

//MARK: - Layout
extension WeatherViewController {
    
    private func createBasicListLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.backgroundColor = .clear
        layoutConfig.headerMode = .supplementary
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:.fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [header]
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let currentWeatherURL = WeatherURLConfigration(weatherType: .current,coordinate: location.coordinate)
        let forecastWeatherURL = WeatherURLConfigration(weatherType: .forecast, coordinate: location.coordinate)
        
        currentWeatherURL.checkError { [weak self] (result: Result<URL,NetworkError>) in
            switch result {
                
            case .success(let success):
                self?.getCurrentWeatherData(url: success)
            case .failure(let failure):
                print(failure.description)
                
            }
        }
        
        forecastWeatherURL.checkError { [weak self] (result: Result<URL,NetworkError>) in
            switch result {
                
            case .success(let success):
                self?.getForecastWeatherData(url: success)
            case .failure(let failure):
                print(failure.description)
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .restricted, .denied:
            showSettingsAlert()
            break
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
            
        }
    }
}

extension WeatherViewController {
    
    private func showSettingsAlert() {
        let alert = UIAlertController(
            title: "위치 권한이 거부되었습니다",
            message: "앱의 모든 기능을 사용하려면 설정에서 위치 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getCurrentWeatherData(url: URL) {
        networkServiceProvider.fetch(url: url) { [weak self] (result: Result<Data, NetworkError>) in
            switch result {
                
            case .success(let currentWeatherData):
                guard let decodedCurrentWeather = self?.jsonLoader.decode(weatherType: self?.current, data: currentWeatherData),
                      let decodedCurrentWeather = decodedCurrentWeather else { return }
                
                DispatchQueue.main.async {
                    self?.updateHeaderUI(decodedCurrentWeather)
                }
                return
            case .failure(let error):
                return print(error.description)
                
            }
        }
    }
    
    private func getForecastWeatherData(url: URL) {
        networkServiceProvider.fetch(url: url) { [weak self] (result: Result<Data, NetworkError>) in
            switch result {
                
            case .success(let forecastWeatherData):
                
                guard let decodedForecastWeather = self?.jsonLoader.decode(weatherType: self?.forecast,
                                                                          data: forecastWeatherData),
                      let decodedForecastWeather = decodedForecastWeather else { return }
                
                self?.forecast = decodedForecastWeather
                
                DispatchQueue.main.async {
                    self?.weatherCollectionView.reloadData()
                }
                return
            case .failure(let error):
                return print(error.description)
                
            }
        }
    }
}

//MARK: - UpdateHeader
extension WeatherViewController: GeoConverter {
    private func updateHeaderUI(_ currentWeather: CurrentWeather) {
        let indexPaths = weatherCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        guard let indexPath = indexPaths.first,
              let header = weatherCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? HeaderCollectionReusableView else { return }
        
        guard let iconName = currentWeather.weather.first?.icon,
              let imageURL = WeatherIconURLConfigration(weatherIcon: iconName).makeURL() else { return }
        
        let location = CLLocation(latitude: currentWeather.coordinate.latitude, longitude: currentWeather.coordinate.longitude)
        
        convertToAddressWith(location: location) { (result: Result<String, GeoConverterError>) in
            
            switch result {
                
            case .success(let name):
                DispatchQueue.main.async {
                    header.updateAddress(covertedName: name)
                }
                return
            case .failure(let fail):
                return print(fail.description)
                
            }
        }
        
        if iconCacheManager.getImage(with: iconName) == nil {
            networkServiceProvider.fetch(url: imageURL) { [weak self] (result: Result<Data, NetworkError>) in
                switch result {
                    
                case .success(let iconData):
                    guard let fetchedIcon = UIImage(data: iconData) else { return }
                    self?.iconCacheManager.storeImage(with: iconName, image: fetchedIcon)
                    DispatchQueue.main.async {
                        header.updateContent(currentWeather, icon: fetchedIcon)
                    }
                    return
                case .failure(let error):
                    return print(error.description)
                    
                }
            }
        } else {
            guard let icon = iconCacheManager.getImage(with: iconName) else { return }
            DispatchQueue.main.async {
                header.updateContent(currentWeather, icon: icon)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let forecast = forecast else { return 0 }
        return forecast.fiveDaysForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastWeatherCell.identifier, for: indexPath) as? ForecastWeatherCell else { return UICollectionViewCell() }
        
        guard let forecast = forecast,
              let iconName = forecast.fiveDaysForecast[indexPath.row].weather.first?.icon,
              let imageURL = WeatherIconURLConfigration(weatherIcon: iconName).makeURL() else { return cell}
        
        if iconCacheManager.getImage(with: iconName) == nil {
            networkServiceProvider.fetch(url: imageURL) { [weak self] (result: Result<Data, NetworkError>) in
                switch result {
                    
                case .success(let iconData):
                    guard let fetchedIcon = UIImage(data: iconData) else { return }
                    self?.iconCacheManager.storeImage(with: iconName, image: fetchedIcon )
                    DispatchQueue.main.async { 
                        cell.updateContent(forecast, indexPath: indexPath, icon: fetchedIcon)
                    }
                    return
                case .failure(let error):
                    return print(error.description)
                    
                }
            }
        } else {
            guard let icon = iconCacheManager.getImage(with: iconName) else { return cell }
            cell.updateContent(forecast, indexPath: indexPath, icon: icon)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        return header
    }
}




