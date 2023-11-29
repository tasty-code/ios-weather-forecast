//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation
import CoreLocation

final class WeatherNetworkManager: NSObject, URLSessionDelegate {
    private var receivedData: Data?
    private var weatherType: WeatherType?
    weak var weatherDelegate: WeatherNetworkManagerDelegate?
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    func loadWeatherData(type: WeatherType, coord: CLLocationCoordinate2D) {
        weatherType = type
        do {
            let request = try WeatherApiClient.makeRequest(weatherType: type, coord: coord)
            let task = session.dataTask(with: request)
            task.resume()
        } catch {
            print(error)
        }
    }
}

// MARK: - URLSessionDataDelegate

extension WeatherNetworkManager: URLSessionDataDelegate {
    
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
            do {
                let data = try JSONDecoder().decode(weatherType.model, from: receivedData)
                weatherDelegate?.weather(self, didLoad: data)
            } catch {
                print(error)
            }
        }
    }
}
