//
//  WeatherForecast - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    private let repository = Repository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserLocation.shared.authorize()
    }
    
    @IBAction func printWeatherInformation(_ sender: UIButton) {
        // let address = try await UserLocation.shared.address()
        // print(address)
        
        guard let location = UserLocation.shared.location?.coordinate else {
            return
        }
        
        URLPath.allCases.forEach { weatherType in
            do {
                try repository.loadData(with: location, path: weatherType) { error in
                    print(error)
                }
            } catch {
                print("URL Fail")
            }
        }
    }
}
