import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private lazy var weatherCollectionView: CollectionView = CollectionView(frame: .zero, collectionViewLayout: createBasicListLayout())
    private lazy var locationManager = CLLocationManager()
    private lazy var networkServiceProvider = NetworkServiceProvider(session: URLSession.shared)
    
    private var forecast: ForecastWeather?
    private var current: CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImageView()
        locationManagerConfiguration()
        
        weatherCollectionView.backgroundColor = .clear
        
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
        networkServiceProvider.fetch(url: url) { (result: Result<Data, NetworkError>) in
            switch result {
                
            case .success(let currentWeatherData):
                
                guard let decodedCurrentWeather = self.networkServiceProvider.decoder(weatherType: self.current, data: currentWeatherData),
                      let decodedCurrentWeather = decodedCurrentWeather else { return }
                
                DispatchQueue.main.async {
                    self.updateHeaderUI(decodedCurrentWeather)
                }
                
                return
            case .failure(let error):
                return print(error.description)
            }
        }
        
    }
    
    private func getForecastWeatherData(url: URL) {
        networkServiceProvider.fetch(url: url) { (result: Result<Data, NetworkError>) in
            switch result {
                
            case .success(let forecastWeatherData):
                
                guard let decodedForecastWeather = self.networkServiceProvider.decoder(weatherType: self.forecast, data: forecastWeatherData),
                      let decodedForecastWeather = decodedForecastWeather else { return }
                
             
                self.forecast = decodedForecastWeather
                
                guard let forecastData = self.forecast else { return }
                
                DispatchQueue.main.async {
                    
                    self.updateCollectionViewCellUI(forecastData)
                }
                
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
        guard let forecast = forecast else { return 0 }
        return forecast.fiveDaysForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastWeatherCell.identifier, for: indexPath) as? ForecastWeatherCell else { return UICollectionViewCell() }
        
        guard let forecast = forecast else { return cell }
//        cell.updateContent(forecast, indexPath: indexPath)
        
        guard let image = forecast.fiveDaysForecast[indexPath.row].weather.first?.icon else { return cell}
        guard let imageURL = WeatherIconURLConfigration(weatherIcon: image).makeURL() else { return cell}
        let indexPaths = weatherCollectionView.indexPathsForVisibleItems
        
        //fetch 사용해야됨
        networkServiceProvider.fetch(url:imageURL) { (result: Result<Data, NetworkError>) in
            switch result {
                
            case .success(let iconData):
                guard let fetchedIcon = UIImage(data: iconData) else { return }
                cell.updateContent(forecast, indexPath: indexPath, icon: fetchedIcon)
                return
            case .failure(let error):
               
                return print(error.description)
            }
            
        }
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

extension WeatherViewController {
    func updateHeaderUI(_ currentWeather: CurrentWeather) {
        let indexPaths = weatherCollectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
        guard let indexPath = indexPaths.first else { return }
        
        guard let header = weatherCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: indexPath) as? HeaderCollectionReusableView else { return }
        
        guard let image = currentWeather.weather.first?.icon else { return }
        guard let imageURL = WeatherIconURLConfigration(weatherIcon: image).makeURL() else { return }
        //fetch 사용해야됨
        networkServiceProvider.fetch(url:imageURL) { (result: Result<Data, NetworkError>) in
            switch result {
                
            case .success(let iconData):
                guard let fetchedIcon = UIImage(data: iconData) else { return }
                DispatchQueue.main.async {
                    header.updateContent(currentWeather, icon: fetchedIcon)
                }
                return
            case .failure(let error):
               
                return print(error.description)
            }
        }
//        self.weatherCollectionView.reloadData()
//        weatherCollectionView.reloadData()
    }
    
    func updateCollectionViewCellUI(_ forecastWeather: ForecastWeather) {
        let indexPaths = weatherCollectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            print("for")
            guard let cell = weatherCollectionView.cellForItem(at: indexPath) as? ForecastWeatherCell else { return }
        }
        
        
        if indexPaths.isEmpty {
            weatherCollectionView.reloadData()
        } else {
            weatherCollectionView.reloadItems(at: indexPaths)
        }
        
    }
}

extension WeatherViewController {
    func setBackgroundImageView() {
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
}
    
