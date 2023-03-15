//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    var model: Model?

    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
    }

    private func callAPI() {
        guard let weatherBaseURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=37.533624&lon=126.963206&appid=") else { return }
        let weatherUrlRequest = URLRequest(url: weatherBaseURL)
        let decoder = JSONDecoder()

        let task = URLSession.shared.dataTask(with: weatherUrlRequest) { data, response, error in
            if let data = data {
                do {
                    try self.model = decoder.decode(Model.self, from: data)
                    print(self.model)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

}

