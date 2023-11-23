import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let weatherManager = NetworkManager<CurrentWeather>()
        
        weatherManager.fetch { result in
            switch result {
            case .success(let weatherResponse):
                print(weatherResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
