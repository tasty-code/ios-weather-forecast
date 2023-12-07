import UIKit
import CoreLocation



final class WeatherViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createBasicListLayout())
        
        return collectionView
    }()
    
    
    private let locationManager = CLLocationManager()
    private let networkServiceProvider = NetworkServiceProvider(session: URLSession.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        collectionView.dataSource = self
        collectionView.delegate = self
        setConstraints()
        
        collectionView.register(ForecastWeatherCell.self, forCellWithReuseIdentifier: ForecastWeatherCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView.backgroundView = setImage()
        
    }
}

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
                print(failure)
                
            }
        }
        
        forecastWeatherURL.checkError { (result: Result<URL,NetworkError>) in
            switch result {
            case .success(let success):
                self.getForecastWeatherData(url: success)
            case .failure(let failure):
                print(failure)
                
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
    
    private func configuration() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func getCurrentWeatherData(url: URL) {
        networkServiceProvider.fetch(url: url) { (result: Result<CurrentWeather, NetworkError>) in
            switch result {
                
            case .success:
                return
            case .failure(let error):
                return print(error)
            }
        }
    }
    
    private func getForecastWeatherData(url: URL) {
        networkServiceProvider.fetch(url: url) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
                
            case .success:
                return
            case .failure(let error):
                return print(error)
            }
        }
    }
    
    func createBasicListLayout() -> UICollectionViewCompositionalLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.backgroundColor = .clear
        layoutConfig.headerMode = .supplementary
        
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        return listLayout
    }
    
    func setConstraints() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true 
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func setImage() -> UIImageView? {
        guard let image = UIImage(named: "nod2.png") else { return nil}
        let imageView = UIImageView(image: image)
        
        return imageView
    }
    


}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastWeatherCell.identifier, for: indexPath) as! ForecastWeatherCell
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
    
        return header
    }
}

extension WeatherViewController: UICollectionViewDelegate{
    
}



