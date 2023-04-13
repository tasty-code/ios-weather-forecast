//
//  WeatherForecast++Bundle.swift
//  WeatherForecast
//
//  Created by 이상윤 on 2023/03/17.
//

import Foundation

extension Bundle {
    var apiKey: String {
        var key = ""
        do {
            key = try getApiKey()
        } catch {
            print(error.localizedDescription)
        }
        return key
    }
    
    private func getApiKey() throws -> String {
        guard let file = self.path(forResource: "WeatherInfo", ofType: "plist") else { throw NetworkError.apiFilePath }
        guard let resource = NSDictionary(contentsOfFile: file) else { throw NetworkError.apiResource }
        guard let key = resource["API_KEY"] as? String, key != "" else { throw NetworkError.apiKey }
        return key
    }
}
