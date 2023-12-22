import UIKit

extension UIImageView {
    static func load(from imageType: String, completion: @escaping (UIImage) -> Void) {
        let networker = Networker()
        
        if let image = CacheManager.shared.loadImage(with: imageType) {
            completion(image)
        } else {
            networker.fetchImage(request: ImageAPI(imageType: imageType)) { image in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
