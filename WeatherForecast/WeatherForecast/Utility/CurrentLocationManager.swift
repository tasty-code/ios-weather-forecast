//
//  CurrentLocationManager.swift
//  WeatherForecast
//
//  Created by 김수경 on 2023/12/01.
//

import CoreLocation

final class CurrentLocationManager {
    private var locationInfo: CurrentLocationInfo?
    private let networkManager: NetworkManagable
    
    init(locationInfo: CurrentLocationInfo? = nil, networkManager: NetworkManagable) {
        self.locationInfo = locationInfo
        self.networkManager = networkManager
    }
    
    func sendRequest<T: Decodable>(path: String, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let queries = try makeQueries()
            networkManager.getData(path: path, with: queries, completion: completion)
        } catch {
            completion(.failure(error))
        }
    }
    
    private func makeQueries() throws -> [String: String] {
        guard let longitude = locationInfo?.coordinates?.longitude,
              let latitude = locationInfo?.coordinates?.latitude
        else {
            throw QueryError.noneCoordinate
        }
        guard let appid = Bundle.main.apiKey
        else {
            throw QueryError.noneAPIKey
        }
        
        let queries = [
            "lon": "\(longitude)",
            "lat": "\(latitude)",
            "appid": appid
        ]
        
        return queries
    }
}

extension CurrentLocationManager: CurrentLocationManagable {
    func updateLocationInfo(with placemark: CLPlacemark) {
        locationInfo = CurrentLocationInfo(
            coordinates: placemark.location?.coordinate,
            city: placemark.locality,
            district: placemark.subLocality
        )
    }
}
