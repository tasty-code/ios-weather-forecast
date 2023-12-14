import Foundation

final class NetworkServiceProvider: NetworkServiceable {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetch<T> (url: URL, completionHandler: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: url) { data, response, error in
            self.handlingDataResponse(data: data, response: response, error: error) { (result: Result<Data, NetworkError>) in
                
                switch result {
                    
                case .success(let success):
                    guard let successData = success as? T else { return }
                    completionHandler(.success(successData))
                case .failure(let failure):
                    return print(failure.description)
                }
            }
        }.resume()
    }
}
