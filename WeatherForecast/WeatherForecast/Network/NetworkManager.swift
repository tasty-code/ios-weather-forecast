//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

class NetworkManager {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchWeatherInformation(of weatherAPI: WeatherAPI, in coordinate: Coordinate) {
        let url = weatherAPI.makeWeatherURL(coordinate: coordinate)
        let urlRequest = URLRequest(url: url)
        
        let task = task(session: session, urlRequest: urlRequest) { error, response, data in
            switch self.handleError(error: error) {
            case .success(let message):
                print(message)
            case .failure(let error):
                print(error.message)
            }
            
            self.handleResponse(response: response)
            
            switch self.handleData(data: data) {
            case .success(let message):
                print(message)
            case .failure(let error):
                print(error.message)
            }
        }
        task.resume()
    }
    
    func task(session: URLSession, urlRequest: URLRequest, completionHandler: @escaping (Error?, URLResponse?, Data?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            completionHandler(error, response, data)
        }
        return task
    }
    
    func handleError(error: Error?) -> NetworkResult {
        guard error == nil else {
            return NetworkError.failedRequest.resultOfNetworkError()
        }
        return .success("Error가 없습니다.")
    }
    
    func handleResponse(response: URLResponse?) {
        switch response?.checkResponse() {
        case .success(let successMessage):
            print(successMessage)
        case .failure(let error):
            print(error.message)
        case .none:
            break
        }
    }
    
    func handleData(data: Data?) -> NetworkResult {
        guard let result = self.decode(from: data, to: FiveDaysForecast.self) else {
            return NetworkResult.failure(NetworkError.failedRequest)
        }
        print(result)
        return NetworkResult.success("성공")
    }
    
    func decode<T: Decodable>(from data: Data?, to type: T.Type) -> T? {
        guard let data = data else { return nil }
        
        let decoder = JSONDecoder()
        print("여기까진 ok")
        do {
            let data = try decoder.decode(type, from: data)
            return data
        } catch {
            print(NetworkError.failedDecoding.message)
            return nil
        }
    }
    
}
