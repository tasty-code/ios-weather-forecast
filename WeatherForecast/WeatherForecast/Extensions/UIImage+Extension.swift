import UIKit

extension UIImage {
    static func load(from imageType: String, completion: @escaping (UIImage) -> Void) {
        let networker = Networker(request: ImageAPI(iconType: imageType))
        
        DispatchQueue.global().async {
            networker.fetchImage { image in
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
