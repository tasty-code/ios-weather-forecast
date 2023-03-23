//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/03/14.
//

import UIKit

final class WeatherAPIManager {
    
    private let networkModel: NetworkModel
    
    init(networkModel: NetworkModel) {
        self.networkModel = networkModel
    }
    
    func fetchWeatherInformation(of weatherAPI: WeatherAPI, in coordinate: Coordinate) {
        
        let url = weatherAPI.makeWeatherURL(coordinate: coordinate)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = networkModel.task(urlRequest: urlRequest, to: weatherAPI.decodingType) { result in
            
            switch result {
            case .success(let data):
                print("Success- 모델 생성완료!")
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
