//
//  IconCacheManager.swift
//  WeatherForecast
//
//  Created by 김경록 on 12/14/23.
//

import UIKit

final class ImageMemoryCacheManager: ImageCacheable {
    private static let cache = NSCache<NSString, UIImage>()
    
    func fetch(by id: String) -> UIImage? {
        let id = NSString(string: id)
        return ImageMemoryCacheManager.cache.object(forKey: id)
    }
    
    func store(with id: String, image: UIImage) {
        let id = NSString(string: id)
        ImageMemoryCacheManager.cache.setObject(image, forKey: id)
    }
}
