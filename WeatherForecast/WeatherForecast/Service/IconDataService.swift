//
//  IconDataService.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation
import UIKit

final class IconDataService: DataServiceable {
    
    func downloadData(type service: ServiceType) throws {
        guard let url = service.makeURL() else { throw NetworkError.invailedURL }
        networkManager.downloadData(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    print("이미지 변환에 실패했습니다.")
                    return
                }
                ImageFileManager.saveImage(image: image, forKey: service.code)
            case .failure(let error):
                print(error)
            }
        }
    }
}
