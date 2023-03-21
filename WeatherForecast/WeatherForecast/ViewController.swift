//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController, NetworkProtocol {
    private(set) var BaseURL: String = "https://api.openweathermap.org/data/2.5/"
    private(set) var appid: String = Bundle.main.apiKey
    private(set) var lat: Double = 37.533624
    private(set) var lon: Double = 126.963206
    private var currentWeather: Weather?
    private var fiveDayWeather: Forecast?

    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
    }

    private func callAPI() {
        let weatherURLString = weatherURL(lat: lat, lon: lon)
        print(weatherURLString)
        guard let weatherURL = URL(string: weatherURLString) else {
            print("invalid URL")
            return
        }
        let weatherURLRequest = URLRequest(url: weatherURL)
        dataTask(URLRequest: weatherURLRequest, myType: Weather.self) { result in
            switch result {
            case .success(let data):
                self.currentWeather = data
            case .failure(let error):
                print("dataTask error: ", error)
            }
        }
        
        let forecastURLString = forecastURL(lat: lat, lon: lon)
        guard let forecastURL = URL(string: forecastURLString) else {
            print("invalid URL")
            return
        }
        let forecastURLRequest = URLRequest(url: forecastURL)
        print(forecastURLString)
        dataTask(URLRequest: forecastURLRequest, myType: Forecast.self) { result in
            switch result {
            case .success(let data):
                self.fiveDayWeather = data
            case .failure(let error):
                print("dataTask error: ", error)
            }
        }
    }
}
