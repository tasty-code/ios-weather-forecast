//
//  ForecastWeatherService.swift
//  WeatherForecast
//
//  Created by Janine on 12/1/23.
//

import Foundation

final class ForecastWeatherService: Request, WeatherServiceProtocol {
    typealias serviceType = FiveDayForecast
    
    private lazy var networkManager = NetworkManager()
    
    var endpointType: Endpoint
    var queryParameters: UrlString?
    var httpMethod: HttpMethod?
    
    var isNetworkingDone: Bool
    var request: URLRequest?
    
    // MARK: - Initialize
    
    init(latitude: String, longitude: String) {
        self.endpointType = .forecast
        self.queryParameters = .weather(latitude: latitude, longitude: longitude)
        
        self.httpMethod = .GET
        self.isNetworkingDone = false
        self.request = makeURLrequest()
    }
    
    // MARK: - Public Method

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
