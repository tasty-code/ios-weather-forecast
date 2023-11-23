//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation

final class NetworkManager: NSObject, URLSessionDelegate {
    private var receivedData: Data?
    private var weatherType: WeatherType?
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    func loadData(type: WeatherType) {
        weatherType = type
        guard let url = ApiClient.makeURL(lat: 37.532600, lon: 127.024612, weatherType: type) else { return }
        let task = session.dataTask(with: url)
        task.resume()
    }
}

// MARK: - URLSessionDataDelegate

extension NetworkManager: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping @Sendable (URLSession.ResponseDisposition) -> Void) {
        guard
            let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode)
        else {
            completionHandler(.cancel)
            return
        }
        
        receivedData = Data()
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        receivedData?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        if
            let receivedData = self.receivedData,
            let weatherType = self.weatherType 
        {
            let dtoData = try! JSONDecoder().decode(weatherType.model, from: receivedData)
            print(dtoData)
        }
    }
}
