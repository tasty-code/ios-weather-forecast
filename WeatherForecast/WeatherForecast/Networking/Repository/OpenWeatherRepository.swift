//
//  OpenWeatherRepository.swift
//  WeatherForecast
//
//  Created by DONGWOOK SEO on 2023/03/14.
//

import UIKit

final class OpenWeatherRepository {
    
    //MARK: - Property
    
    private let deserializer: Deserializerable
    private let service: NetworkService
    
    //MARK: - LifeCycle

    init(
        deserializer: Deserializerable,
        service: NetworkService
    ) {
        self.deserializer = deserializer
        self.service = service
    }

    // MARK: - Constant

    private enum Constant {
        static let baseURL = "https://api.openweathermap.org"
        static let baseIconURL = "https://openweathermap.org"

        static let weatherPath = "/data/2.5/weather"
        static let forecastPath = "/data/2.5/forecast"
        static func iconImagePath(withID id: String) -> String { "/img/wn/\(id)@2x.png" }

        static let latitudeQueryName = "lat"
        static let longitudeQueryName = "lon"
        static let appIdQueryName = "appid"
        static let languageQueryName = "lang"
        static let koreanLanguageQueryValue = "kr"
        static let unitsQueryName = "units"
        static let celsiusUnitsQueryValue = "metric"
    }

    // MARK: - Public

    func fetchData<T: Decodable>(type: T.Type,
                                 endpoint: OpenWeatherAPIEndpoints,
                                 completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let urlRequest = endpoint.urlRequest else { return }

        service.performRequest(with: urlRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try self.deserializer.deserialize(T.self, data: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.parse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchWeatherIconImage(withID iconID: String, completion: @escaping (UIImage?) -> Void) {
        if let iconImage = ImageCacheManager.shared.get(for: iconID) {
            completion(iconImage)
            return
        }

        let urlRequest = OpenWeatherAPIEndpoints.iconImage(id: iconID).urlRequest

        service.performRequest(with: urlRequest) { result in
            switch result {
            case .success(let data):
                if let icon = UIImage(data: data) {
                    ImageCacheManager.shared.store(icon, for: iconID)
                    completion(icon)
                }
                completion(nil)
            case .failure:
                completion(nil)
            }
        }
    }

    // MARK: - Private

    private func generateIconImageURL(withID iconID: String) -> URL? {
        guard var urlComponents = URLComponents(string: Constant.baseIconURL) else {
            return nil
        }
        urlComponents.path = Constant.iconImagePath(withID: iconID)
        return urlComponents.url
    }

    private func generateURL(withPath path: String,
                             coordinate: Coordinate) -> URL? {
        guard var urlComponents = URLComponents(string: Constant.baseURL) else {
            return nil
        }

        urlComponents.path = path
        urlComponents.queryItems = generateQueryItems(coordinate: coordinate)

        return urlComponents.url
    }

    private func generateQueryItems(coordinate: Coordinate) -> [URLQueryItem] {
        return [
            URLQueryItem(name: Constant.latitudeQueryName, value: "\(coordinate.latitude)"),
            URLQueryItem(name: Constant.longitudeQueryName, value: "\(coordinate.longitude)"),
            URLQueryItem(name: Constant.appIdQueryName, value: Bundle.main.apiKey),
            URLQueryItem(name: Constant.languageQueryName, value: Constant.koreanLanguageQueryValue),
            URLQueryItem(name: Constant.unitsQueryName, value: Constant.celsiusUnitsQueryValue)
        ]
    }
    
}
