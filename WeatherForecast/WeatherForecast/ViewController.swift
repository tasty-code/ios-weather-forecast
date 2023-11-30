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
    let locationManager = WeatherLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    func configureURLRequest(_ coordinate: CLLocationCoordinate2D) -> URLRequest? {
        guard let url = WeatherURLManager().getURL(api: .weather, latitude: coordinate.latitude, longitude: coordinate.longitude) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        return urlRequest
    }
}

extension ViewController: WeatherUIDelegate {
    func loadForecast(_ coordinate: CLLocationCoordinate2D) {
        guard let urlRequest = configureURLRequest(coordinate) else {
            return
        }
        
        let publisher = URLSession.shared.publisher(request: urlRequest)
        subscriber =  WeatherHTTPClient.publishForecast(from: publisher, forecastType: CurrentWeather.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    self?.countryLabel.text = error.localizedDescription
                }
            } receiveValue: { [weak self] weather in
                self?.countryLabel.text = weather.system.country
            }
    }
    
    func updateAddress(_ addressString: String) {
        addressLabel.text = addressString
    }
}
