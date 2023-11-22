import Foundation

protocol Weatherable {
    func fetch(_ weatherType: WeatherType, completion: @escaping (Result<DataTransferable, NetworkError>) -> Void)
}

final class WeatherManager: Weatherable {
    func fetch(_ weatherType: WeatherType, completion: @escaping (Result<DataTransferable, NetworkError>) -> Void) {
        var url : URL?
        do {
            url = try URL(string: "https://api.openweathermap.org/data/2.5/\(weatherType.description)?lat=37.715122&lon=126.734086&appid=\(apiKey)")
        } catch {
            print(error)
        }
        
        let DTO = weatherType.check()
        
        guard let url = url else {
            return completion(.failure(.noExistedUrl))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return completion(.failure(.noExistedData))
            }
            do {
                let weatherResponse = try JSONDecoder().decode(DTO, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}

extension Weatherable {
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
