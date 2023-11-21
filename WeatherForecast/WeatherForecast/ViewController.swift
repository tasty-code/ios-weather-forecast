//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    var weather: CurrentWeatherDTO?
    var fiveWeather: FiveDaysWeatherDTO?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentWeatherManager().fetchWeather(completion: { result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    print(self.fiveWeather)
                }
            case .failure(_ ):
                print("error")
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        guard let url: URL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=37.715122&lon=126.734086&appid=0ed6b11be2fec878e365b4e35230b834") else { return }
//        let session: URLSession = URLSession(configuration: .default)
//        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
//        
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard let data = data else { return }
//            
//            do{
//                let fiveWeather = try JSONDecoder().decode(FiveDaysWeatherDTO.self, from: data)
//                self.fiveWeather = fiveWeather
//                
//                DispatchQueue.main.async {
//                    print(self.fiveWeather)
//                }
//                
//            } catch(let err) {
//                print(err.localizedDescription)
//            }
//        }
//        dataTask.resume()
//        
    }
}

