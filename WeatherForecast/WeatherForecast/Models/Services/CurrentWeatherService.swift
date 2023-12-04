//
//  CurrentWeatherService.swift
//  WeatherForecast
//
//  Created by Janine on 12/1/23.
//

import Foundation

final class CurrentWeatherService: Request, WeatherServiceProtocol {
    typealias serviceType = CurrentWeather
    
    private lazy var networkManager = NetworkManager()
    
    var endpointType: Endpoint
    var queryParameters: UrlString?
    var httpMethod: HttpMethod?
    
    var isNetworkingDone: Bool
    var request: URLRequest?
    
    init(latitude: String, longitude: String) {
        self.endpointType = .weather
        self.queryParameters = .weather(latitude: latitude, longitude: longitude)
        self.httpMethod = .GET
        self.isNetworkingDone = false
        self.request = makeURLrequest()
    }
    
    func fetcher(_ completionHandler: @escaping (_ data: serviceType) -> Void) {
        self.isNetworkingDone = false
        
        networkManager.execute(request, expecting: serviceType.self) { result in
            switch result {
            case .success(let success):
                self.isNetworkingDone = true
                completionHandler(success)
            case .failure:
                break
            }
        }
    }
}
