//
//  IconDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 12/1/23.
//

import UIKit

final class IconDataService: DataDownloadable {
    private weak var delegate: ImageDataServiceDelegate?
    
    init(delegate: ImageDataServiceDelegate) {
        self.delegate = delegate
    }
    
    func downloadData(serviceType: ServiceType) {
        guard let url = serviceType.makeURL() else { return }
        
        NetworkManager.downloadData(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    guard let self = self, let image = image else { return }
                    self.delegate?.notifyImageDidUpdate(dataService: self, image: image)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
