import Foundation

protocol NetworkServiceable {
    
    func fetch<T: Decodable>(url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void)
    
    func handlingDataResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<T, NetworkError>) -> Void)
}

extension NetworkServiceable {
    
    func handlingDataResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
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
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completionHandler(.success(decodedData))
        } catch {
            print(error)
            completionHandler(.failure(.decodingError))
        }
    }
}
