import Foundation
import UIKit

protocol ImageCache {
    func object(forKey key: URL) -> UIImage?
    func setObject(_ obj: UIImage, forKey key: URL)
}

final class ImageCacheImpl: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    func object(forKey key: URL) -> UIImage? {
        return cache.object(forKey: key as NSURL)
    }

    func setObject(_ obj: UIImage, forKey key: URL) {
        return cache.setObject(obj, forKey: key as NSURL)
    }
}
