import UIKit
import CoreLocation

final class WeatherForecastViewController: UIViewController {
    private let weatherForecastView = WeatherForecastView()
    private let locationManager = LocationManager()
    private var model: Decodable?
    private var networker: Networker<Model.CurrentWeather>?
    
    override func loadView() {
        view = weatherForecastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.request { [self] result in
            switch result {
            case.success((let coordinate, let placemark)):
                print(coordinate)
                print(placemark)
                
                networker = Networker<Model.CurrentWeather>(request: WeatherAPI.current(coordinate))
                
                networker?.fetchWeatherData { [weak self] weatherResponse in
                    self?.model = weatherResponse
                    print(self?.model)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
