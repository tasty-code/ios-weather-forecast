//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

final class WeatherNetworkDispatcher {
    
    private let networkSession: NetworkSession
    private let deserializer = JSONNetworkDeserializer(decoder: JSONDecoder())
    
    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }
    
    func makeWeatherRequest(of weatherAPI: WeatherAPI, in coordinate: Coordinate) -> URLRequest {
        let url = weatherAPI.makeWeatherURL(coordinate: coordinate)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
    
    func makeImageRequest(_ icon: String) -> URLRequest {
           let url = WeatherAPI.makeImageURL(icon: icon)
           var urlRequest = URLRequest(url: url)
           urlRequest.httpMethod = "GET"
           return urlRequest
       }
    
    func requestWeatherInformation(of weatherAPI: WeatherAPI, in coordinate: Coordinate, completion: @escaping (Decodable?) -> Void) {
            
            let urlRequest = makeWeatherRequest(of: weatherAPI, in: coordinate)
            
            let task = networkSession.task(urlRequest: urlRequest) { result in
                
                switch result {
                case .success(let data):
                    do {
                        let decodedData = try self.deserializer.deserialize(data: data, to: weatherAPI.decodingType)
                        completion(decodedData)
                    } catch {
                        print(error.localizedDescription)
                        completion(nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }

            task.resume()
        }
    
    func requestWeatherImage(icon: String, completion: @escaping (UIImage?) -> Void) {
            
            let urlRequest = makeImageRequest(icon)
            
            let task = networkSession.task(urlRequest: urlRequest) { result in
                
                switch result {
                case .success(let data):
                    completion(UIImage(data: data))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
            
            task.resume()
        }
}
 
