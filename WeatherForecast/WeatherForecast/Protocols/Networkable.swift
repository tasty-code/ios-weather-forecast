import Foundation

protocol Networkable {
    func fetch(_ weatherType: WeatherType, completion: @escaping (Result<DataTransferable, NetworkError>) -> Void)
}

extension Networkable {
    var apiKey: String {
        get throws {
            guard let filePath = Bundle.main.path(forResource: "APIKeyList", ofType: "plist") else {
                throw APIError.noExistedAPIPlist
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "OPENWEATHERMAP_KEY") as? String else {
                throw APIError.noExistedAPIKey
            }
            return value
        }
    }
}
