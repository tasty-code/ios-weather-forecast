import Foundation
import UIKit

struct Networker {
    private let networkManager: NetworkManager

    init(request: Requestable) {
        self.networkManager = NetworkManager(request: request)
    }
    
    func fetchWeatherData<T: Decodable>(completion: @escaping (T) -> Void) {
        
        networkManager.fetch { (result: Result<T, NetworkError>) in
            switch result {
            case .success(let weatherResponse):
                completion(weatherResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
}
