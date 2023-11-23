import Foundation

protocol Networkable {
    func fetch(completion: @escaping (Result<DataTransferable, NetworkError>) -> Void)
}
