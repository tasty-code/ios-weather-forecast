import UIKit

final class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let networker = Networker<Model.CurrentWeather>(request: WeatherAPI.current)
        networker.fetchWeatherData()
    }
}
