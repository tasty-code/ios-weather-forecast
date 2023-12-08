//
//  ForecastDataService.swift
//  WeatherForecast
//
//  Created by 김예준 on 12/8/23.
//

import Foundation

final class ForecastDataService: DataServiceable {
    weak var delegate: ForecastDataServiceDelegate?
    
    func downloadData(type service: ServiceType) {
        // TODO: throw error catching
        guard let url = service.makeURL() else { return }
        networkManager.downloadData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let decodeData = try self.decoder.decode(WeatherForecast.self, from: data)
                    self.delegate?.forecastDataService(self, didDownload: decodeData)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
