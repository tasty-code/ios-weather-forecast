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
    func updatePlacemark(placemark: CLPlacemark) {
        print(placemark)
    }
    
    func updateUI(coordinate: CLLocationCoordinate2D?) {
        print(coordinate)
        
        networker.fetchWeatherData { weatherResponse in
            print(weatherResponse)
        }
    }
}
