//
//  IconService.swift
//  WeatherForecast
//
//  Created by Janine on 12/3/23.
//

import Foundation

final class IconService {
    typealias serviceType = Data
    
    private lazy var cache = CacheManager()
    private lazy var endpointType: Endpoint = .icon
    
    // MARK: - public Method
    func getIcon(by iconId: String) -> NSObject? {
        return cache.getCache(id: iconId)
    }
    
    func setIconCache(data: NSObject, forKey iconId: String) {
        cache.setCache(id: iconId, data: data)
    }
    
    func fetchIcon(iconId: String, group: DispatchGroup) {
        if cache.getCache(id: iconId) != nil {
            return
        }
        
        let urlString = endpointType.baseUrl + UrlString.icon(iconId: iconId).parameter
        let url = URL(string: urlString)
        
        DispatchQueue.global().async(group: group) {
            do {
                let icon = try Data(contentsOf: url!)
                self.cache.setCache(id: iconId, data: icon as NSObject)
            } catch {
                print("아이콘 불러오기 실패")
            }
        }
    }
}
