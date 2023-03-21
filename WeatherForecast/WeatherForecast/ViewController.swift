//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController, NetworkTaskProtcol {
    private var currentWeather: Weather?
    private var fiveDayWeather: Forecast?
    private var appid: String{
        return Bundle.main.apiKey
    }
    lazy var weatherKey: String = "https://api.openweathermap.org/data/2.5/weather?lat=37.533624&lon=126.963206&appid=\(appid)"
    lazy var forecastKey = "https://api.openweathermap.org/data/2.5/forecast?lat=37.533624&lon=126.963206&appid=\(appid)"

    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
    }

    private func callAPI() {
        guard let weatherURL = URL(string: weatherKey) else {
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
        
        guard let forecastURL = URL(string: forecastKey) else {
            print("invalid URL")
            return
        }
        let forecastURLRequest = URLRequest(url: forecastURL)
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

