//
//  IconDataService.swift
//  WeatherForecast
//
//  Created by Swain Yun on 12/1/23.
//

import UIKit

final class IconDataService: DataDownloadable {
    private weak var delegate: ImageDataServiceDelegate?
    private let cacheManager = CacheManager<NSString, UIImage>()
    
    init(delegate: ImageDataServiceDelegate) {
        self.delegate = delegate
    }
    
    func downloadData(serviceType: ServiceType) {
        guard let url = serviceType.makeURL() else { return }
        let cacheKey = NSString(string: url.lastPathComponent)
        
        guard let cachedImage = cacheManager.fetchCache(key: cacheKey) else {
            NetworkManager.downloadData(url: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    guard let image = UIImage(data: data) else { return }
                    self.cacheManager.storeCache(key: cacheKey, value: image)
                    DispatchQueue.main.async {
                        self.delegate?.notifyImageDidUpdate(dataService: self, image: image)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            return
        }
        
        delegate?.notifyImageDidUpdate(dataService: self, image: cachedImage)
    }
}
