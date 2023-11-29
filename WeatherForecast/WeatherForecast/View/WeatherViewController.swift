import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    let location = CLLocationManager()
    var coordinate = Coordinate(longitude: 0.0, latitude: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
}

extension WeatherViewController {
    private func configuration() {
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
    
    private func getCurrentWeatherData() {
        NetworkService.getWeatherData(weatherType: .current , coordinate: coordinate){ (result: Result<CurrentWeather, NetworkError>) in
            switch result {
            case .success:
                return
            case .failure:
                return
            }
        }
    }
    
    private func getForecastWeather() {
        NetworkService.getWeatherData(weatherType: .forecast, coordinate: coordinate) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case .success:
                return
            case .failure:
                return
            }
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate, GeoConverter{
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
       
        let latitude = location.coordinate.latitude as Double
        let longitude = location.coordinate.longitude as Double
        coordinate.latitude = latitude
        coordinate.longitude = longitude
        
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
