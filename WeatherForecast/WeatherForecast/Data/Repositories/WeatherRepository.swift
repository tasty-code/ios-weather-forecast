//
//  WeatherRepository.swift
//  WeatherForecast
//
//  Created by devxsby on 2023/03/30.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeather(completion: @escaping (Result<WeatherEntitiy, Error>) -> Void)
}

final class WeatherRepository: WeatherRepositoryProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchWeather(completion: @escaping (Result<WeatherEntitiy, Error>) -> Void) {
        let url = "\(NetworkConfig.baseURL)/weather?lat=\(37.53)&lon=\(126.96)&appid=\(SecretKey.appId)&lang=kr"
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, error == nil else {
                completion(.failure(error ?? NSError()))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(WeatherEntitiy.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
