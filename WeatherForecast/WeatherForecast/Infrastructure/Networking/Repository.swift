//
//  Repository.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/16.
//

import CoreLocation

enum NetworkEntityLoadingError: Error {
    case networkFailure(Error)
    case invalidData
}

class Repository {
    typealias Handler = (Result<WeatherModel, NetworkEntityLoadingError>) -> Void
    
    private let session = URLSession.shared

    func loadWeatherEntity(with location: CLLocationCoordinate2D, path: URLPath, then completion: @escaping Handler) throws {
        let url = try URLPath.configureURL(of: path, with: location)
        
        let task = session.dataTask(with: url) { [self] result in
            switch result {
            case .success(let data):
                if let wishData = loadJSON(weatherType: path.weatherMetaType, weatherData: data) {
                    completion(.success(wishData))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure(let error):
                completion(.failure(.networkFailure(error)))
            }
        }
        task.resume()
    }
    
    private func loadJSON(weatherType: WeatherModel.Type, weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let wishData = try decoder.decode(weatherType, from: weatherData)
            return wishData
        } catch {
            print("Unable to decode \(weatherData): (error)")
            return nil
        }
    }
}

private extension URLSession {
    func dataTask(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }

            if let data = data {
                completion(.success(data))
            }
        }
    }
}
