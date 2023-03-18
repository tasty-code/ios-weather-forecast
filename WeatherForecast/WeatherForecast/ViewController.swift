//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    var currentWeather: CurrentWeather?
    var fiveDayWeather: FiveDayWeather?
    let appid = Bundle.main.apiKey
    let currentWeatherKey = "https://api.openweathermap.org/data/2.5/weather?lat=37.533624&lon=126.963206&appid="
    let fiveDayWeatherKey = "https://api.openweathermap.org/data/2.5/forecast?lat=37.533624&lon=126.963206&appid="

    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
    }

    private func callAPI() {
        let decoder = JSONDecoder()
        guard let currentWeatherBaseURL = URL(string: currentWeatherKey + appid) else { return }
        let weatherURLRequest = URLRequest(url: currentWeatherBaseURL)
        let currentWeatherTask = URLSession.shared.dataTask(with: weatherURLRequest) { data, response, error in
            if let data = data {
                do {
                    try self.currentWeather = decoder.decode(CurrentWeather.self, from: data)
                    print("currentWeather: ",self.currentWeather)
                } catch {
                    print(error)
                }
            }
        }
        currentWeatherTask.resume()
        
        guard let fiveDayWeatherBaseURL = URL(string: fiveDayWeatherKey + appid) else { return }
        let fiveDayURLRequest = URLRequest(url: fiveDayWeatherBaseURL)
        let fiveDayWeatherTask = URLSession.shared.dataTask(with: fiveDayURLRequest) { data, response, error in
            if let data = data {
                do {
                    try self.fiveDayWeather = decoder.decode(FiveDayWeather.self, from: data)
                    print("fiveDayWeather: ",self.fiveDayWeather)
                } catch {
                    print(error)
                }
            }
        }
        fiveDayWeatherTask.resume()
    }

}

