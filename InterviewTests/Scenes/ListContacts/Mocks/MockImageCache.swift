import Foundation
import UIKit
@testable import Interview

class MockImageCache: ImageCache {
    private var cache: [URL: UIImage] = [:]

    func object(forKey key: URL) -> UIImage? {
        return cache[key]
    }

    func setObject(_ obj: UIImage, forKey key: URL) {
        cache[key] = obj
    }
}
