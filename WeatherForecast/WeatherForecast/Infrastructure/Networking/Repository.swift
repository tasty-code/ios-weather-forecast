//
//  Repository.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/16.
//

import CoreLocation

class Repository {
    
    //MARK: - Private Property

    private let session = URLSession.shared
    
    //MARK: - Public Method
    
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
    
    func loadIcon(completion: @escaping (Data?, Error?) -> Void) {

        certifiedMakeURL { [self] url in
            var urlRequest = URLRequest(url: url)

            urlRequest.httpMethod = "GET"
            session.dataTask(with: urlRequest) { (data, response, error) in
                guard error == nil else {
                    completion(nil, error)
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
                completion(data, nil)
            }.resume()
        }
    }
    
    //MARK: - Private Method
    
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

//MARK: - Make Icon URL

extension Repository {
    private func certifiedMakeURL(completion: @escaping (URL) -> Void) {
        URLPath.iconList.forEach { iConElement in
            try? completion(URLPath.configureIconURL(of: iConElement))
        }
    }
}
