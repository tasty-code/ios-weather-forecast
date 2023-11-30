import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private let locationManager = LocationManager.shared
    private var model: Decodable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.request { [self] result in
            switch result {
            case.success((let coordinate, let placemark)):
                print(coordinate)
                print(placemark)
                
                let networker = Networker<Model.CurrentWeather>(request: WeatherAPI.current)
                
                networker.fetchWeatherData { [weak self] weatherResponse in
                    self?.model = weatherResponse
                    print(self?.model)
                    //        model 받아서 ColletionView로 넘겨준다.
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
