//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController, URLSessionDelegate, URLSessionTaskDelegate {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let weatherURL = NetworkManager(lat: 37.532600, lon: 127.024612).components?.url else { return }
        let request = URLRequest(url: weatherURL)
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard 
                let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) 
            else {
                print("Error: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                //print(json)
                let weatherForecast = try! JSONDecoder().decode(WeatherToday.self, from: data)
                print(weatherForecast)
            } catch let error {
                print("Error: \(error.localizedDescription)")
            }
            
        }
        
        task.resume()
        
    }


}
