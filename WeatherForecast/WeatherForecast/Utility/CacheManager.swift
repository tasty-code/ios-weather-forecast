import UIKit

final class CacheManager {
    
    private static let shared = NSCache<NSString, UIImage>()

    func getImage(with imageID: String) -> UIImage? {
        let id = NSString(string: imageID)
        if let image = CacheManager.shared.object(forKey: id) {
            return image
        }

        return nil
    }

    func storeImage(with imageID: String, image: UIImage) {
        let id = NSString(string: imageID)
        CacheManager.shared.setObject(image, forKey: id)
    }
}
