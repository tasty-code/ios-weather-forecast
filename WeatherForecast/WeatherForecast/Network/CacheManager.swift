//
//  CacheManager.swift
//  WeatherForecast
//
//  Created by Rarla on 2023/12/01.
//

import Foundation

final class CacheManager<DataType: NSObject> {
    private let cache = NSCache<NSString, DataType>()
    
    func setCache(id: String, data: DataType) {
        cache.setObject(data, forKey: id as NSString)
    }
    
    func getCache(id: String) -> DataType? {
        guard let cached = cache.object(forKey: id as NSString) else { return nil }
        return cached
    }
}
