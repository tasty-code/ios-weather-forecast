import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        NetworkService().getWeatherData(informationType: .weather, latitude: 37.6, longitude: 127.3) { (result: Result<CurrentWeather, NetworkError>) in
            switch result {
            case .success(let weatherInformation ):
               return print(weatherInformation)
            case .failure(_ ):
               return print("error")
            }
        }
        
        NetworkService().getWeatherData(informationType: .forecast, latitude: 37.6, longitude: 127.3) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case .success(let weatherInformation):
               return print(weatherInformation)
            case .failure(_ ):
               return print("error")
            }
        }
    }
}



