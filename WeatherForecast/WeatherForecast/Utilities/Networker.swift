import Foundation

final class Networker<T: Decodable> {
    private let networkManager: NetworkManager<T>

    init(request: Requestable) {
        self.networkManager = NetworkManager<T>(request: request)
    }
    
    func fetchWeatherData() {
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
