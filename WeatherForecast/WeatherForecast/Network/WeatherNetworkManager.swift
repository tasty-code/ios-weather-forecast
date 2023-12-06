//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 김예준 on 11/21/23.
//

import Foundation
import CoreLocation

final class WeatherNetworkManager<T: Decodable>: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    static var shared: WeatherNetworkManager<T> {
        return WeatherNetworkManager<T>()
    }
    typealias ResponseClosure = (T) -> Void
    var responseClosure: ResponseClosure?
    
    private var receivedData: Data?
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    func loadWeatherData(type: WeatherType, coord: CLLocationCoordinate2D) {
        do {
            let request = try WeatherApiClient.makeRequest(weatherType: type, coord: coord)
            let task = session.dataTask(with: request)
            task.resume()
        } catch {
            print(error)
        }
    }
    
    // MARK: - URLSessionDataDelegate
    
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
        
        if let receivedData = self.receivedData {
            do {
                let data = try JSONDecoder().decode(T.self, from: receivedData)
                if let responseClosure {
                    responseClosure(data)
                }
            } catch {
                print(error)
            }
        }
    }
}
