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
}

extension WeatherViewController: CLLocationManagerDelegate, GeoConverter{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        convertToAddressWith(coordinate: location)
        let latitude = location.coordinate.latitude as Double
        let longitude = location.coordinate.longitude as Double
        coordinate.latitude = latitude
        coordinate.longitude = longitude
        
        NetworkService().getWeatherData(keyName: "API_KEY", weatherType: .current, coordinate: coordinate){ (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case .success(let weatherInformation ):
                return
            case .failure(_ ):
                return
            }
        }
        NetworkService().getWeatherData(keyName: "API_KEY", weatherType: .forecast, coordinate: coordinate) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case .success(let weatherInformation ):
                return
            case .failure(_ ):
                return
            }
        }
        
    }
}


