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
        
        UserLocation.shard.authorize()
    }
    
    @IBAction func printWeatherInformation(_ sender: UIButton) {
        Task {
            do {
                let address = try await UserLocation.shard.address()
                print(address)

                guard let location = UserLocation.shard.location?.coordinate else {
                    return
                }

                try URLPath.allCases.forEach { weatherType in
                    try repository.loadWeatherEntity(with: location, path: weatherType) { result in
                        switch result {
                        case .success(let data):
                            print(data)
                        case .failure(.invalidData):
                            print("유효하지 않은 데이터")
                        case .failure(.networkFailure(let error)):
                            print("네트워크 실패, \(error)")
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
