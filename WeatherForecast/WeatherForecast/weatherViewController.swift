import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    let location = CLLocationManager()
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = self
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
          latitude = location.coordinate.latitude
          longitude = location.coordinate.longitude
        }
        print(latitude, longitude)
    }
}
