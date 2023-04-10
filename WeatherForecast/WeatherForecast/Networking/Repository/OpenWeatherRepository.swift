//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/14.
//

import UIKit

final class OpenWeatherRepository {
    
    //MARK: - Property
    
    private let deserializer: Deserializerable
    private let service: NetworkService
    
    //MARK: - LifeCycle

    init(
        deserializer: Deserializerable,
        service: NetworkService
    ) {
        self.deserializer = deserializer
        self.service = service
    }

    // MARK: - Public

    func fetchData<T: Decodable>(type: T.Type,
                                 endpoint: OpenWeatherAPIEndpoints,
                                 completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = endpoint.urlRequest else { return }

        service.performRequest(with: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try self.deserializer.deserialize(T.self, data: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.parse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchWeatherIconImage(withID iconID: String, completion: @escaping (UIImage?) -> Void) {
        if let iconImage = ImageCacheManager.shared.get(for: iconID) {
            completion(iconImage)
            return
        }

        let urlRequest = OpenWeatherAPIEndpoints.iconImage(id: iconID).urlRequest

        service.performRequest(with: urlRequest) { result in
            switch result {
            case .success(let data):
                if let icon = UIImage(data: data) {
                    ImageCacheManager.shared.store(icon, for: iconID)
                    completion(icon)
                }
                completion(nil)
            case .failure:
                completion(nil)
            }
        }
    }

}
