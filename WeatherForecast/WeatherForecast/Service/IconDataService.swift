//
//  IconDataService.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation
import UIKit

final class IconDataService: DataServiceable {
    weak var delegate: IconDataServiceDelegate?
    
    func downloadData(type service: ServiceType) {
        guard let url = service.makeURL() else { return } // TODO: { throw NetworkError.invailedURL }
        networkManager.downloadData(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return } // TODO: 이미지 파일 변환 실패
                ImageCacheManager.setCache(image: image, forKey: service.code)
                self.delegate?.didCompleteLoad(self)
            case .failure(let error):
                print(error)
            }
        }
    }
}
