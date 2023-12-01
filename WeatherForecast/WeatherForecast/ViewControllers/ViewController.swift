import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let locationManager = LocationManager()
    private var model: Decodable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.request { result in
            switch result {
            case.success((let coordinate, let placemark)):
                print(coordinate)
                print(placemark)
                
                let networker = Networker<Model.CurrentWeather>(request: WeatherAPI.current(coordinate))
                
                networker.fetchWeatherData { [weak self] weatherResponse in
                    self?.model = weatherResponse
                    print(self?.model)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
