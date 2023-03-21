//
//  Repository.swift
//  WeatherForecast
//
//  Created by Jason on 2023/03/16.
//

import Foundation
import CoreLocation

class Repository {
    func loadData(type: URLPath, location: CLLocationCoordinate2D) throws {
        let url = try URLPath.configureURL(coordintate: location, getPath: type)
        
        let session = URLSession.shared
        
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
            
            guard let wishData = self.loadJSON(weatherType: type.getWeatherMetaType, weatherData: data) else {
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
