//
//  WeatherImageCache.swift
//  WeatherForecast
//
//  Created by 김준성 on 12/8/23.
//

import Foundation
import UIKit

final class WeatherImageCache {
    public static let shared = WeatherImageCache()
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    
    func fetch(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    func store(_ uiImage: UIImage?, to nsURL: NSURL) {
         guard let uiImage = uiImage else {
             return
         }
         cachedImages.setObject(uiImage, forKey: nsURL)
     }
    
    func load(from url: URL, completion: @escaping (UIImage?) -> Void) {
        guard let nsURL = NSURL(string: url.formatted()) else {
            completion(nil)
            return
        }
        
        if let cacheImage = fetch(url: nsURL) {
            DispatchQueue.main.async {
                completion(cacheImage)
            }
            return
        }
        
        let subscriber = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint(error)
                }
            } receiveValue: { (data, response) in
                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    debugPrint("리스폰스 오류")
                    completion(nil)
                    return
                }
                guard let image = UIImage(data: data) else {
                    debugPrint("이미지 오류")
                    completion(nil)
                    return
                }
                
                self.cachedImages.setObject(image, forKey: nsURL)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        subscriber.cancel()
    }
}
