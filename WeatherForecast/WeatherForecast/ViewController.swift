import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherType = WeatherType.fiveDaysWeahter
        let weatherManager = NetworkManager()
        
        weatherManager.fetch(weatherType) { result in
            switch result {
            case .success(let weatherResponse):
                print(weatherResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
