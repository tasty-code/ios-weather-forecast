//
//  WeatherForecastDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/22/23.
//

import Foundation
import CoreLocation

protocol DataServiceDelegate: AnyObject {
    func notifyWeatherModelDidUpdate(dataService: WeatherForecastDataService, model: Decodable?)
    func notifyForecastModelDidUpdate(dataService: WeatherForecastDataService, model: Decodable?)
    func notifyPlacemarkDidUpdate(dataService: WeatherForecastDataService, currentPlacemark: CLPlacemark?)
}

protocol WeatherForecastDataServiceProtocol {
    func fetchData(_ serviceType: ServiceType, location: CLLocation)
    func reverseGeocodeLocation(location: CLLocation)
}

final class WeatherForecastDataService: WeatherForecastDataServiceProtocol {
    private var weatherModel: Decodable? = nil
    private var forecastModel: Decodable? = nil
    private var currentPlacemark: CLPlacemark? = nil
    private weak var delegate: DataServiceDelegate?
    
    init(dataServiceDelegate: DataServiceDelegate) {
        self.delegate = dataServiceDelegate
    }
    
    func fetchData(_ serviceType: ServiceType, location: CLLocation) {
        guard let url = generateURL(serviceType, location: location) else { return }
        
        downloadData(url: url, serviceType: serviceType)
    }
    
    func reverseGeocodeLocation(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
            guard error == nil else { return }
            guard let placemark = placemarks?.last else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.currentPlacemark = placemark
                self.delegate?.notifyPlacemarkDidUpdate(dataService: self, currentPlacemark: currentPlacemark)
            }
        }
    }
}

// MARK: Private Methods
extension WeatherForecastDataService {
    private func generateURL(_ serviceType: ServiceType, location: CLLocation) -> URL? {
        guard let apiKey = Bundle.getAPIKey(for: ApiName.openWeatherMap.name) else {
            return nil
        }
        
        let urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(serviceType.urlPath)")
        let queries = [
            URLQueryItem(name: "lat", value: "\(location.coordinate.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.coordinate.longitude)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        
        guard let url = NetworkManager.makeURL(urlComponents, queries: queries) else {
            return nil
        }
        
        return url
    }
    
    private func downloadData(url: URL, serviceType: ServiceType) {
        NetworkManager.downloadData(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                let model = self?.decodeJSONToSwift(data, serviceType: serviceType)
                
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch serviceType {
                    case .weather:
                        self.weatherModel = model
                        self.delegate?.notifyWeatherModelDidUpdate(dataService: self, model: model)
                    case .forecast:
                        self.forecastModel = model
                        self.delegate?.notifyForecastModelDidUpdate(dataService: self, model: model)
                    }
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    private func decodeJSONToSwift(_ data: Data, serviceType: ServiceType) -> Decodable? {
        do {
            let model = try JSONDecoder().decode(serviceType.decodingType, from: data)
            return model
        } catch {
            guard let error = error as? DecodingError else { return nil }
            print("Failed to Decoding JSON: \(error)")
        }
        
        return nil
    }
}
