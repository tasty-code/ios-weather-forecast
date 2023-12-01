import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private let networkServiceProvider = NetworkServiceProvider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
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
}


