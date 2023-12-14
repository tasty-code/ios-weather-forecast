//
//  WeatherImageManager.swift
//  WeatherForecast
//
//  Created by BOMBSGIE on 2023/12/14.
//

import UIKit

final class WeatherImageManager: ImageUpdatable {
    private let networkManager: NetworkManagable
    private let urlFormatter: any URLFormattable = WeatherImageURLFormatter()
    
    init(networkManager: NetworkManagable) {
        self.networkManager = networkManager
    }
    
    func requestImage(name: String, completion: @escaping (UIImage?) -> ()) {
        networkManager.getData(formatter: urlFormatter, path: WeatherImageURL.image(icon: name).path, with: nil) { result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    completion(UIImage(data: imageData))
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
}

protocol ImageUpdatable: AnyObject {
    func requestImage(name: String, completion: @escaping (UIImage?) -> ())
}
