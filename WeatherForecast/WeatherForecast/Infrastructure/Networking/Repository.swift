//
//  Repository.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/16.
//

import CoreLocation

enum NetworkEntityLoadingError: Error {
    case networkFailure
    case invalidData
}

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

enum NetworkError: Error {
    case notConnected
}

enum HTTPResponseError: Error {
    case error(statusCode: Int, description: String)
    
}

class Repository {
    typealias Handler = (Result<WeatherModel, NetworkEntityLoadingError>) -> Void
    
    private let session = URLSession.shared
    
    func loadData(with location: CLLocationCoordinate2D, path: URLPath, completion: @escaping (Error) -> Void) throws {
        let url = try URLPath.configureURL(of: path, with: location)
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethodType.get.rawValue
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(NetworkError.notConnected)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let responseError = HTTPResponseError.error(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 404,
                                                            description: response.debugDescription)
                completion(responseError)
                return
            }
            
            guard let data = data else {
                completion(NetworkEntityLoadingError.networkFailure)
                return
            }
            
            guard let wishData = self.loadJSON(weatherType: path.weatherMetaType, weatherData: data) else {
                completion(NetworkEntityLoadingError.invalidData)
                return
            }
            print(wishData)
        }.resume()
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
