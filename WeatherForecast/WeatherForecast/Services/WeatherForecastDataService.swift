//
//  WeatherForecastDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 11/22/23.
//

import Foundation
import CoreLocation

protocol DataServiceDelegate: AnyObject {
    func notifyModelDidUpdate(dataService: WeatherForecastDataService, model: Decodable?)
    func notifyPlacemarkDidUpdate(dataService: WeatherForecastDataService, currentPlacemark: CLPlacemark?)
}

final class WeatherForecastDataService {
    private let networkManager: NetworkDownloadable
    private var model: Decodable? = nil
    private var currentPlacemark: CLPlacemark? = nil
    
    weak var delegate: DataServiceDelegate? = nil
    
    init(networkManager: NetworkDownloadable) {
        self.networkManager = networkManager
    }
    
    func fetchData(_ serviceType: ServiceType, location: CLLocation) {
        let builder = NetworkBuilder(for: serviceType)
        networkManager.downloadData(builder) { [weak self] result in
            switch result {
            case let .success(data):
                let model = self?.decodeJSONToSwift(data, serviceType: serviceType)
                self?.model = model
                
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.delegate?.notifyModelDidUpdate(dataService: self, model: model)
                }
            case let .failure(error):
                print(error)
            }
        }
        
        reverseGeocodeLocation(location: location)
    }
}

// MARK: Private Methods
extension WeatherForecastDataService {
    private func reverseGeocodeLocation(location: CLLocation) {
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
