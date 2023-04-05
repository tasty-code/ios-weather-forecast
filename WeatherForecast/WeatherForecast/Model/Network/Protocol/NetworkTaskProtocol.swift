//
//  NetworkTaskProtcol.swift
//  WeatherForecast
//
//  Created by 신동오 on 2023/03/21.
//

import Foundation

protocol NetworkTaskProtcol {
    func dataTask<T: Decodable>(URLRequest: URLRequest, myType: T.Type, completion: @escaping (Result<T,Error>)->())
    func decode<T: Decodable>(jsonData: Data, type: T.Type) -> T?
}

extension NetworkTaskProtcol {
    
    func dataTask<T: Decodable>(URLRequest: URLRequest, myType: T.Type, completion: @escaping (Result<T,Error>)->()) {
        
        let myTask = URLSession.shared.dataTask(with: URLRequest) { data, response, error in
            
            if let data = data {
                guard let decodedData = self.decode(jsonData: data, type: myType) else { return }
                completion(.success(decodedData))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
        
        myTask.resume()
    }
    
    func decode<T: Decodable>(jsonData: Data, type: T.Type) -> T? {
        do {
            let data = try JSONDecoder().decode(type.self, from: jsonData)
            return data
        } catch {
            print(NetworkError.decodeError.localizedDescription, type)
            return nil
        }
    }
}
