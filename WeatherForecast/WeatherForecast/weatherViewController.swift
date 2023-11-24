import UIKit

class WeatherViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let coordinate = Coordinate(longitude: 127.3, latitude: 37.6)
        
        NetworkService().getWeatherData(keyName: "API_KEY",weatherType: .current , coordinate: coordinate) { (result: Result<CurrentWeather, NetworkError>) in
            switch result {
            case .success(let weatherInformation ):
               return print(weatherInformation)
            case .failure(let error):
                return print(error.description)
            }
        }
        
        NetworkService().getWeatherData(keyName: "API_KEY",weatherType: .forecast, coordinate: coordinate) { (result: Result<ForecastWeather, NetworkError>) in
            switch result {
            case .success(let weatherInformation):
               return print(weatherInformation)
            case .failure(let error ):
                return print(error.description)
            }
        }
    }
}



