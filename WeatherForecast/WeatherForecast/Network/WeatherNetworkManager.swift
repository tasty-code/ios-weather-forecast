////
////  WeatherNetworkManager.swift
////  WeatherForecast
////
////  Created by 김예준 on 11/21/23.
////
//

import Foundation
import CoreLocation

final class WeatherNetworkManager {
    func downloadData(url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completionHandler(.failure(NetworkError.failedTask))
                return
            }
            guard
                let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode)
            else {
                return completionHandler(.failure(NetworkError.notSuccessCode))
            }
            
            guard let data = data else {
                return completionHandler(.failure(NetworkError.failedToLoadData))
            }
            
            completionHandler(.success(data))
        }.resume()
    }
}
