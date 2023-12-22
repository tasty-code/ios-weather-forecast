//
//  TodayDataService.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

final class TodayDataService: DataServiceable {
    weak var delegate: TodayDataServiceDelegate?
    
    func downloadData(type service: ServiceType) throws {
        guard let url = service.makeURL() else { throw NetworkError.invailedURL }
        networkManager.downloadData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodeData = try self.decoder.decode(WeatherToday.self, from: data)
                    self.delegate?.todayDataService(self, didDownload: decodeData)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
