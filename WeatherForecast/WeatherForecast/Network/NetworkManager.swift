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
            self.handleError(result: self.checkError(error))
            self.handleResponse(response: response)
            self.convertData(from: data, to: weatherAPI.decodingType)
        }
        task.resume()
    }
    
    func task(session: URLSession, urlRequest: URLRequest, completionHandler: @escaping (Error?, URLResponse?, Data?) -> Void) -> URLSessionDataTask {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            completionHandler(error, response, data)
        }
        return task
    }
    
    func checkError(_ error: Error?) -> NetworkResult {
        guard error == nil else {
            return NetworkError.failedRequest.resultOfNetworkError()
        }
        return .success("Error가 없습니다.")
    }
    
    func handleError(result: NetworkResult) {
        switch result {
        case .success(let message):
            print(message)
        case .failure(let error):
            print(error.message)
        }
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
    
    func convertData<T: Decodable>(from data: Data?, to type: T.Type) {
        guard let result = decode(from: data, to: type) else { return }
        print("결과야 \(result)")
    }
    
    func decode<T: Decodable>(from data: Data?, to type: T.Type) -> T? {
        guard let data = data else { return nil }
        
        let decoder = JSONDecoder()
        print("여기까진 ok")
        do {
            let data = try decoder.decode(type, from: data)
            return data
        } catch {
            return nil
        }
    }
    
}
