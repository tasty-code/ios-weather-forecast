import Foundation

struct Networker<T: Decodable> {
    private let networkManager: NetworkManager<T>

    init(request: Requestable) {
        self.networkManager = NetworkManager<T>(request: request)
    }
    
    func fetchWeatherData(completion: @escaping (T) -> Void) {
        networkManager.fetch { result in
            switch result {
            case .success(let weatherResponse):
                completion(weatherResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
}
