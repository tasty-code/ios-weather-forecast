import UIKit
import CoreLocation

final class ViewController: UIViewController {
    private var currentLocation: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        let networker = Networker<Model.CurrentWeather>(request: WeatherAPI.current)
        networker.fetchWeatherData()
    }
}
