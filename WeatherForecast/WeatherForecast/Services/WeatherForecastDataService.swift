//
//  WeatherForecastDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/22/23.
//

import Foundation
import CoreLocation

final class WeatherForecastDataService {
    private var model: Decodable? = nil
    
    func fetchData(_ serviceType: ServiceType, coordinate: CLLocationCoordinate2D) {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else {
            return
        }
        
        let urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(serviceType.name)")
        let queries = [
            URLQueryItem(name: "lat", value: "\(33.44)"),
            URLQueryItem(name: "lon", value: "\(128.12)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = NetworkManager.makeURL(urlComponents, queries: queries, serviceType: serviceType) else {
            return
        }
        
        NetworkManager.downloadData(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                let model = self?.decodeJSONToSwift(data, serviceType: serviceType)
                DispatchQueue.main.async {
                    self?.model = model
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    func readModel() -> Decodable? {
        return model
    }
}

// MARK: Private Methods
extension WeatherForecastDataService {
    private func decodeJSONToSwift(_ data: Data?, serviceType: ServiceType) -> Decodable? {
        do {
            guard let data = data else { return nil }
            let model = try JSONDecoder().decode(serviceType.decodingType, from: data)
            return model
        } catch {
            guard let error = error as? DecodingError else { return nil }
            print("Failed to Decoding JSON: \(error)")
        }
        
        return nil
    }
}
