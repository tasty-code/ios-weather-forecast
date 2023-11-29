import Foundation

protocol Networkable: AnyObject {
    associatedtype T
    
    func fetch(completion: @escaping (Result<T, NetworkError>) -> Void)
}
