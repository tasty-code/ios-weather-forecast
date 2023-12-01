//
//  CacheManager.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/12/01.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    
    func setCache(id: String, data: UIImage) {
        cache.setObject(data, forKey: id as NSString)
    }
    
    func getCache(id: String) -> UIImage? {
        guard let image = cache.object(forKey: id as NSString) else { return nil }
        return image
    }
}
