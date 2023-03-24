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
    
    let session = URLSession.shared
    
    func loadData(location: CLLocationCoordinate2D, path: URLPath) throws {
        let url = try URLPath.configureURL(of: path, with: location)
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                if (error as? URLError)?.code == .timedOut {
                    print(error?.localizedDescription ?? error.debugDescription)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print((response as? HTTPURLResponse)?.statusCode ?? 404)
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let wishData = self.loadJSON(weatherType: path.weatherMetaType, weatherData: data) else {
                return
            }
            print(wishData)
        }.resume()
    }
    
    //MARK: - URL Result Test
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

extension URLSession {
    func dataTask(with url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(data ?? Data()))
            }
        }
    }
}
