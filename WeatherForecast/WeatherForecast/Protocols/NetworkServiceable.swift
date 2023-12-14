import Foundation

protocol NetworkServiceable {
    
    func fetch<T> (url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void)
    
    func handlingDataResponse(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
}

extension NetworkServiceable {
    
    func handlingDataResponse(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let data = data, error == nil else {
            return completionHandler(.failure(.invalidData))
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return completionHandler(.failure(.invalidResponse))
        }
        
        guard (200..<300) ~= httpResponse.statusCode else {
            print(httpResponse.statusCode)
            return completionHandler(.failure(.invalidResponse))
        }
        
        completionHandler(.success(data))
    }
    
    func decoder<T: Decodable> (weatherType: T, data: Data) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print(NetworkError.decodingError.description)
            return nil
        }
    }
}
