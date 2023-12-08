import UIKit
import CoreLocation

final class WeatherForecastViewController: UIViewController {
    private let weatherForecastView = WeatherForecastView()
    private let locationManager = LocationManager()
    private var currentWeatherNetworker: Networker<Model.CurrentWeather>?
    private var fiveDaysWeatherNetworker: Networker<Model.FiveDaysWeather>?
    
    override func loadView() {
        view = weatherForecastView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.request { [weak self] result in
            switch result {
            case.success((let coordinate, let placemark)):
                self?.weatherForecastView.sendLocation(placemark.locality, placemark.subLocality)
                
                self?.currentWeatherNetworker = Networker<Model.CurrentWeather>(request: WeatherAPI.current(coordinate))
   

                self?.currentWeatherNetworker?.fetchWeatherData { [weak self] weatherResponse in
                    print(weatherResponse)
                    self?.weatherForecastView.sendCurrentWeatherModel(model: weatherResponse, placemark: placemark)
                }
                
                self?.fiveDaysWeatherNetworker = Networker<Model.FiveDaysWeather>(request: WeatherAPI.fiveDays(coordinate))
                self?.fiveDaysWeatherNetworker?.fetchWeatherData { [weak self] weatherResponse in
                    print(weatherResponse)
                    self?.weatherForecastView.sendFiveDaysWeatherModel(model: weatherResponse)
                    DispatchQueue.main.async {
                        self?.weatherForecastView.collectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

