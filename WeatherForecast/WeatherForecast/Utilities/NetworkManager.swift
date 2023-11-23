import Foundation

final class NetworkManager<T: DataTransferable>: Networkable, KeyAuthenticatable {
    internal var apiKey: String {
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
    
    func fetch(completion: @escaping (Result<DataTransferable, NetworkError>) -> Void) {
        var url : URL?
        do {
            url = try URL(string: "https://api.openweathermap.org/data/2.5/\(T.name)?lat=37.715122&lon=126.734086&appid=\(apiKey)")
        } catch {
            return completion(.failure(.urlError))
        }
        
        guard let url = url else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return completion(.failure(.unknownError))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.handleServerError(response: response)))
            }
            guard let data = data else {
                return completion(.failure(.dataUnwrappingError))
            }
            do {
                let weatherResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}
