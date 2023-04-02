//
//  ForecastRepository.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

//final class ForecastRepository {
//
//    private let networkService: NetworkService
//
//    init(service: NetworkService) {
//        self.networkService = service
//    }
//}
//
//extension ForecastRepository: ForecastRepositoryInterface {
//    func fetchForecast() {
//
//    }
//}

final class ForecastRepository {
    func fetchForecast(completion: @escaping (ForecastEntity) -> Void) {
        
//        request(coordinate: coordinate, path: NetworkConfig.URLPath.weather.rawValue, completion: completion)
        let url = "\(NetworkConfig.baseURL)/forecast?lat=\(37.53)&lon=\(126.96)&appid=\(SecretKey.appId)&lang=kr"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, _, _ in
            guard let data = data else { return }
            guard let model = try? JSONDecoder().decode(ForecastEntity.self, from: data) else { return }
            
            completion(model)
        }.resume()
    }
}
