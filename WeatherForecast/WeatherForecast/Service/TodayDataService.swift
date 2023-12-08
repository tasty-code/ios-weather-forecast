//
//  TodayDataService.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

final class TodayDataService {
    let decoder = JSONDecoder()
    let networkManager = WeatherNetworkManager()
    weak var delegate: TodayDataServiceDelegate?
    
    func downloadData(type service: ServiceType) {
        // TODO: throw error catching
        guard let url = service.makeURL() else { return }
        networkManager.downloadData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodeData = try self.decoder.decode(WeatherToday.self, from: data)
                    self.delegate?.todayData(self, didDownload: decodeData)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
