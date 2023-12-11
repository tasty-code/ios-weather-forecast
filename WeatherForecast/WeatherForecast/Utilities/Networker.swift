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
    
    func fetchImage(completion: @escaping (UIImage) -> Void) {
        networkManager.fetchImage { result in
            switch result {
            case .success(let image):
                completion(image)
            case .failure(let error):
                print(error)
            }
        }
    }
}
