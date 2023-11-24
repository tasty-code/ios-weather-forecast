import Foundation

final class Networker<T: Decodable> {
    private var networkManager: NetworkManager<T>?

    func fetchWeatherData() {
        networkManager = NetworkManager<T>(request: WeatherAPI.current)
        
        guard let networkManager = networkManager else {
            return
        }
        
        networkManager.fetch { result in
            switch result {
            case .success(let weatherResponse):
                print(weatherResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
}
