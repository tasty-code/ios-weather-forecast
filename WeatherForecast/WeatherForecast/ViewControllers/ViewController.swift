import UIKit
import CoreLocation

final class ViewController: UIViewController, CLLocationManagerDelegate {
    private let locationManager = LocationManager.shared
    private let networker = Networker<Model.CurrentWeather>(request: WeatherAPI.current)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
}

extension ViewController: UILocationDelegate {
    func update(placemark: CLPlacemark) {
        print(placemark)
    }
    
    func update(coordinate: CLLocationCoordinate2D?) {
        print(coordinate)
        
        networker.fetchWeatherData { weatherResponse in
            print(weatherResponse)
        }
    }
}
