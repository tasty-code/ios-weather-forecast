import Foundation

protocol Networkable {
    associatedtype T
    
    func fetch(completion: @escaping (Result<T, NetworkError>) -> Void)
}
