import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkService().getWeatherData(informationType: .weather, latitude: 37.6, longitude: 127.3) { (result: Result<CurrentWeather, NetworkError>) in
            switch result {
            case.success(_ ):
                print("성공")
            case.failure(_ ):
                print("error")
            }
        }
        NetworkService().getWeatherData(informationType: .forecast, latitude: 37.6, longitude: 127.3) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case.success(_ ):
                print("성공")
            case.failure(_ ):
                print("error")
            }
            
        }
    }
    
}

