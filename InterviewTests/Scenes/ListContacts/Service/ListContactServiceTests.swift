import XCTest
@testable import Interview

final class ListContactServiceTests: XCTestCase {
    
    func givenJsonErrorWhenFetchingContactsThenResultFetchingDataError() {
        let mockSession = MockURLSession()
        let mockCache = MockImageCache()
        let contactService = ListContactServiceImpl(session: mockSession, cache: mockCache)

        mockSession.nextData = nil

        let expectation = self.expectation(description: "Contacts fetch failed")

        contactService.fetchContacts { response in
            switch response {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .fetchingData)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func givenURLErrorWhenFetchingContactsThenResultParsingURLError() {
        
    }
    
    func givenSuccessfullyDecodeJsonWhenFetchingContactsThenResultCorrectContactInfo() {
        
    }
}


var mockData: Data? {
    """
    [{
      "id": 2,
      "name": "Beyonce",
      "photoURL": "https://api.adorable.io/avatars/285/a2.png"
    }]
    """.data(using: .utf8)
}
