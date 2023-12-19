import UIKit

extension UIImageView {
    static func load(from imageType: String, completion: @escaping (UIImage) -> Void) {
        let networker = Networker()
        
        DispatchQueue.global().async {
            networker.fetchImage(request: ImageAPI(imageType: imageType)) { image in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
