import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private lazy var weatherCollectionView: CollectionView = CollectionView(frame: .zero, collectionViewLayout: createBasicListLayout())
    private lazy var locationManager = CLLocationManager()
    private lazy var networkServiceProvider = NetworkServiceProvider(session: URLSession.shared)

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerConfiguration()
        
        weatherCollectionView.dataSource = self
        weatherCollectionView.delegate = self
        weatherCollectionView.setCollectionViewConstraints(view: view)
    }
}

//MARK: - CLLocationManagerDelegate , GeoConverter
extension WeatherViewController: CLLocationManagerDelegate, GeoConverter{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let currentWeatherURL = WeatherURLConfigration(weatherType: .current,coordinate: location.coordinate)
        let forecastWeatherURL = WeatherURLConfigration(weatherType: .forecast, coordinate: location.coordinate)
        
        currentWeatherURL.checkError { (result: Result<URL,NetworkError>) in
            switch result {
            case .success(let success):
                self.getCurrentWeatherData(url: success)
            case .failure(let failure):
                print(failure.description)
                
            }
        }
        
        forecastWeatherURL.checkError { (result: Result<URL,NetworkError>) in
            switch result {
            case .success(let success):
                self.getForecastWeatherData(url: success)
            case .failure(let failure):
                print(failure.description)
                
            }
        }
        
        convertToAddressWith(location: location) { (result: Result<String, GeoConverterError>) in
            switch result {
                
            case .success:
                return
            case .failure:
                return
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension WeatherViewController {
    
    private func locationManagerConfiguration() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func getCurrentWeatherData(url: URL) {
        networkServiceProvider.fetch(url: url) { (result: Result<CurrentWeather, NetworkError>) in
            switch result {
                
            case .success(let currentWeatherData):
                DispatchQueue.main.async {
                    self.updateHeaderUI(currentWeatherData)
                }
                return
            case .failure(let error):
                return print(error.description)
            }
        }
    }
    
    private func getForecastWeatherData(url: URL) {
        networkServiceProvider.fetch(url: url) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
                
            case .success(let forecastWeatherData):
//                DispatchQueue.main.async {
//                    self.updateCollectionViewCellUI(forecastWeatherData)
//                }
                return
            case .failure(let error):
                return print(error.description)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastWeatherCell.identifier, for: indexPath) as? ForecastWeatherCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
        

    
        return header
    }
}

extension WeatherViewController: UICollectionViewDelegate{
    
}

//MARK: - Layout
extension WeatherViewController {
    
    private func createBasicListLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.backgroundColor = .clear
        layoutConfig.headerMode = .supplementary
        
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        return listLayout
    }
}

extension WeatherViewController {
    
    func updateHeaderUI(_ currentWeather: CurrentWeather) {
        let indexPaths = weatherCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        guard let indexPath = indexPaths.first else { return }
        
        guard let header = weatherCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? HeaderCollectionReusableView else { return }
        
        header.updateContent(currentWeather)
        weatherCollectionView.reloadItems(at: indexPaths)
    }
    
    func updateCollectionViewCellUI(_ forecastWeather: ForecastWeather) {
        let indexPaths = weatherCollectionView.indexPathsForVisibleItems
        
        
        
        if indexPaths.isEmpty {
            weatherCollectionView.reloadData()
        } else {
            weatherCollectionView.reloadItems(at: indexPaths)
        }
        
    }
}
