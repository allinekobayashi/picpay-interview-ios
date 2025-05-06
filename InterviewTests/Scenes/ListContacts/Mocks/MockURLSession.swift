import Foundation
@testable import Interview

final class MockURLSession: URLSessionProtocol {
    var nextData: Data?
    var nextError: Error?
    var lastURL: URL?

    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> any Interview.URLSessionDataTaskProtocol {
        lastURL = url
        return MockURLSessionDataTask {
            completionHandler(self.nextData, nil, self.nextError)
        }
    }
}
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        closure()
    }
}
