import XCTest
@testable import Interview

final class ListContactInteractorTests: XCTestCase {
    func loadContactsTestsGivenFetchContactsSucesfullyAndNotLegacy() {
        let service = MockListContactService()
        let serviceResponse = [ContactResponse(
            id: 2,
            name: "Beyonce",
            photoURL: "https://api.adorable.io/avatars/285/a2.png"
        )]
        let expectedData = [Contact(
            id: 2,
            name: "Beyonce",
            photoURL: URL(string:"https://api.adorable.io/avatars/285/a2.png"),
            alert: .init(title: "Você tocou em", message: "Beyonce")
        )]
        
        service.response = .success(serviceResponse)
        
        let interactor = ListContactInteractorImpl(service: service)

        let expectation = self.expectation(description: "Load contacts sucessfully")
        interactor.loadContacts { response in
            switch response {
            case let .success(data):
                XCTAssertEqual(expectedData, data)
            case .failure:
                XCTFail("Expected success but got failed")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1)
    }
}
