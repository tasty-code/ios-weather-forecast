//
//  Repository.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/16.
//

import CoreLocation

class Repository {
    typealias Handler = (Result<WeatherModel, NetworkEntityLoadingError>) -> Void
    
    private let session = URLSession.shared
    
    func loadData(with location: CLLocationCoordinate2D, path: URLPath, completion: @escaping (WeatherModel?, Error?) -> Void) {
        
        do {
            let url = try URLPath.configureURL(of: path, with: location)
            var urlRequest = URLRequest(url: url)
            
            urlRequest.httpMethod = "GET"
            session.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(nil, NetworkError.notConnected)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    let responseError = HTTPResponseError.error(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 404,
                                                                description: response.debugDescription)
                    completion(nil, responseError)
                    return
                }
                
                guard let data = data else {
                    completion(nil, NetworkEntityLoadingError.networkFailure)
                    return
                }
                
                guard let wishData = self.loadJSON(weatherType: path.weatherMetaType, weatherData: data) else {
                    completion(nil, NetworkEntityLoadingError.invalidData)
                    return
                }
                completion(wishData, nil)
            }.resume()
        } catch {
            completion(nil, error)
        }
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
