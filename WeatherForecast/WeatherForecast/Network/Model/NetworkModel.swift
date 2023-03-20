//
//  NetworkModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/17.
//

import UIKit

typealias NetworkResult = Result<Decodable, NetworkError>

final class NetworkModel {
    private let session = URLSession.shared
    
    func task<DecodedData: Decodable>(urlRequest: URLRequest,
                                      to type: DecodedData.Type,
              completionHandler: @escaping (NetworkResult) -> Void
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
            
            guard let decodedData = self.decode(from: data, to: type) else { return completionHandler(.failure(.failedDecoding))}
            
            completionHandler(.success(decodedData))
        }
        
        return task
    }
    
    func decode<DecodedData: Decodable>(from data: Data, to type: DecodedData.Type) -> DecodedData? {
        
        let decoder = JSONDecoder()
        
        do {
            let data = try decoder.decode(type, from: data)
            return data
        } catch {
            return nil
        }
    }
}
