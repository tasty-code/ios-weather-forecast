//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation

class NetworkManager: NSObject {
    var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/")
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    override init() {
        components?.path += "forecast/"
        let apiKey = URLQueryItem(name: "appid", value: Sequrity.weatherApiKey)
        components?.queryItems?.append(apiKey)
    }
    
    init(lat: Double, lon: Double) {
        components?.path += "weather/"
        let latQueryItem = URLQueryItem(name: "lat", value: String(lat))
        let lonQueryItem = URLQueryItem(name: "lon", value: String(lon))
        let apiKey = URLQueryItem(name: "appid", value: Sequrity.weatherApiKey)
        components?.queryItems = [latQueryItem, lonQueryItem, apiKey]
    }
    
    func startLoad() {
        guard let url = self.components?.url else { return }
        let task = session.dataTask(with: url)
        task.resume()
    }
}

// MARK: - URLSessionDataDelegate

extension NetworkManager: URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping @Sendable (URLSession.ResponseDisposition) -> Void) {
        guard
            let response = response as? HTTPURLResponse,
            (200...299).contains(response.statusCode),
            let mimeType = response.mimeType,
            mimeType == "application/json"
        else {
            completionHandler(.cancel)
            return
        }
        
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let weatherForecast = try! JSONDecoder().decode(WeatherToday.self, from: data)
        print(weatherForecast)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
    }
}
