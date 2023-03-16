//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let location = CLLocationCoordinate2D(latitude: 44.34, longitude: 10.99)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = try? URLPath.configureURL(coordintate: location, getPath: .weather)
    }
}


enum URLPath: String {
    case weather = "weather"
    case forecast = "forecast"
    
    static func configureURL(coordintate: CLLocationCoordinate2D, getPath: URLPath) throws -> URL {
        guard var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/\(getPath.rawValue)") else {
            throw URLError.FailOfURLComponents
        }
        
        let latitude = URLQueryItem(name: "latitude", value: coordintate.latitude.description)
        let longitude = URLQueryItem(name: "longitude", value: coordintate.longitude.description)
        let appid = URLQueryItem(name: "appid", value: Bundle.main.APIKey)
        let unitsOfMeasurement = URLQueryItem(name: "units", value: "metric")
        let countOfDay = URLQueryItem(name: "cnt", value: "5")
        
        components.queryItems = [latitude, longitude, appid, unitsOfMeasurement, countOfDay]
        
        guard let url = components.url else {
            throw URLError.FailOfMakeURL
        }
        
        return url
    }
}

enum URLError: LocalizedError {
    case FailOfURLComponents
    case FailOfMakeURL
}
