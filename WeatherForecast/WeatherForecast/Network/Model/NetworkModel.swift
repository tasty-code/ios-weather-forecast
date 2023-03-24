//
//  NetworkModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/17.
//

import UIKit

typealias NetworkResult = Result<Data, NetworkError>

final class NetworkModel {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func task(urlRequest: URLRequest, completionHandler: @escaping (NetworkResult) -> Void
    ) -> URLSessionDataTask {
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completionHandler(.failure(.failedRequest))
                return
            }
            
            guard let response = response, response.checkResponse else {
                completionHandler(.failure(.outOfReponseCode))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.emptyData))
                return
            }
                        
            completionHandler(.success(data))
        }
        
        return task
    }
    
    func decode(from data: Data, to type: Decodable.Type) throws -> Decodable? {
        
        let decoder = JSONDecoder()
        let data = try decoder.decode(type, from: data)
        return data
    }
}
