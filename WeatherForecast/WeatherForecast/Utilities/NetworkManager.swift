//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/20/23.
//

import Foundation

final class NetworkManager {
    private enum ResponseStatus {
        case success, failure
        
        static func check(_ statusCode: Int) -> ResponseStatus {
            switch statusCode {
            case 200..<300: ResponseStatus.success
            default: ResponseStatus.failure
            }
        }
    }
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func downloadData(url: URL, _ completionHandler: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                return print("error occured")
            }
            
            guard let data = data, let response = response as? HTTPURLResponse,
                  ResponseStatus.check(response.statusCode) == .success 
            else {
                return
            }
            
            completionHandler(data)
        }.resume()
    }
}
