//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

final class ViewController: UIViewController {
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    var subscriber: AnyCancellable?
    var locationM = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [self] in
            makeUI()
        }
    }
    
    private func makeUI() {
        guard let url = WeatherURLManager().getURL(api: .weather, latitude: locationM.lat, longitude: locationM.lon)
        else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let publisher = URLSession.shared.publisher(request: urlRequest)
        subscriber =  WeatherHTTPClient.publishForecast(from: publisher, forecastType: CurrentWeather.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self.countryLabel.text = error.localizedDescription
                    print(error)
                }
            } receiveValue: { weather in
                
                self.countryLabel.text = weather.system.country
                self.addressLabel.text = self.locationM.address
            }
    }
}
