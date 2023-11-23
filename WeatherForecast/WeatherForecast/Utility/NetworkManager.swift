//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/11/22.
//

import Foundation

final class NetworkManager {
    private let urlFormatter: any URLFormattable
    private let session: URLSession
    
    init(urlFormatter: any URLFormattable, session: URLSession = URLSession.shared) {
        self.urlFormatter = urlFormatter
        self.session = session
    }
    
    func getData<T: Decodable>(path: String, with queries: [String: String], completion: @escaping (Result<T, NetworkError>) -> Void) {
          guard let url = urlFormatter.makeURL(path: path, with: queries) else {
              return
          }
            
          let task = session.dataTask(with: url) { data, response, error in
              if let error = error {
                  return completion(.failure(.unknownError(description: error.localizedDescription)))
              }
              
              guard let response = response as? HTTPURLResponse else {return}
              guard (200..<300).contains(response.statusCode)
              else {
                  return completion(.failure(.responseError(statusCode: response.statusCode)))
              }
              
              guard let data = data
              else {
                  return completion(.failure(.emptyDataError))
              }
              do {
                  let decodingData = try JSONDecoder().decode(T.self, from: data)
                  completion(.success(decodingData))
              } catch {
                  completion(.failure(.decodingError))
              }
          }
          task.resume()
      }
      


}
