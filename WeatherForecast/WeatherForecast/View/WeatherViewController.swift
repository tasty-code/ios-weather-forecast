import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    private let location = CLLocationManager()
    private var coordinate = Coordinate(longitude: 0.0, latitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}

extension WeatherViewController {
    private func configuration() {
        location.delegate = self
        location.desiredAccuracy = kCLLocationAccuracyKilometer
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
    
    private func getCurrentWeatherData() {
        WeatherNetworkService.getWeatherData(weatherType: .current, coordinate: coordinate){ (result: Result<CurrentWeather, NetworkError>) in
            switch result {
            case .success:
                return
            case .failure(let error):
                return print(error.description)
            }
        }
    }
    
    private func getForecastWeatherData() {
        WeatherNetworkService.getWeatherData(weatherType: .forecast, coordinate: coordinate) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case .success:
                return
            case .failure(let error):
                return print(error.description)
            }
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate, GeoConverter{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let latitude = location.coordinate.latitude as Double
        let longitude = location.coordinate.longitude as Double
        
        coordinate.latitude = latitude
        coordinate.longitude = longitude
        
        getCurrentWeatherData()
        getForecastWeatherData()
        convertToAddressWith(coordinate: location) { (result: Result<String, GeoConverterError>) in
            switch result {
            case .success:
                return
            case .failure:
                return
            }
        }
    }
}
