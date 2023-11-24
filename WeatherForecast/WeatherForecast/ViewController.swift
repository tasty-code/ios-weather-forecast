//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var countryLabel: UILabel!
    var subscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = WeatherURLManager().getURL(api: .weather, latitude: 40, longitude: -73)
        else {
            return
        }
        
        let publisher = URLSession.shared.publisher(request: URLRequest(url: url))
        subscriber =  WeatherHTTPClient.publishForecast(from: publisher, forecastType: CurrentWeather.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self.countryLabel.text = error.localizedDescription
                }
            } receiveValue: { weather in
                self.countryLabel.text = weather.system.country
            }
    }


}

